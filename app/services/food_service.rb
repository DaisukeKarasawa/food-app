class FoodService
  include DateConverter

  class << self
    def list_available_foods
      Food.includes(:dishes, :shops).not_expired.by_deadline.map do |food|
        day, remain = build_converter.changeToDate(food.deadline)
        next unless remain

        {
          id: food.id,
          name: food.name,
          day: day,
          remains: remain,
          price: food.price,
          dishes: food.dishes,
          shops: food.shops
        }
      end.compact
    end

    def find_food_by_name(name)
      food = Food.includes(:dishes, :shops).find_by(name: name)
      return nil unless food

      _, remain = build_converter.changeToDate(food.deadline)
      
      {
        id: food.id,
        name: food.name,
        remains: remain || FoodConstants::MESSAGES[:purchase_required],
        price: food.price,
        dishes: food.dishes,
        shops: food.shops
      }
    end

    def create_food(name:, deadline:, price:, dishes: [], shop:)
      raise Errors::FoodAlreadyExistsError.new(name) if Food.exists?(name: name)

      # Validate deadline format
      day, remain = build_converter.changeToDate(deadline)
      raise Errors::InvalidDeadlineError.new unless remain

      ActiveRecord::Base.transaction do
        food = Food.create!(
          name: name,
          deadline: deadline,
          price: price
        )

        # Link to shop
        shop_record = Shop.find_or_create_by(name: shop)
        FoodsShop.find_or_create_by(shop: shop_record, food: food)

        # Link to dishes if provided
        if dishes.present?
          dishes.each do |dish_name|
            dish = Dish.find_by(name: dish_name)
            raise Errors::DishNotFoundError.new(dish_name) unless dish
            
            DishesFood.find_or_create_by(dish: dish, food: food)
          end
        end

        food
      end
    end

    def update_food(name:, **attributes)
      food = Food.find_by(name: name)
      raise Errors::FoodNotFoundError.new(name) unless food

      ActiveRecord::Base.transaction do
        # Validate deadline if provided
        if attributes[:deadline].present?
          day, remain = build_converter.changeToDate(attributes[:deadline])
          raise Errors::InvalidDeadlineError.new unless remain
        end

        food.update!(attributes.slice(:deadline, :price))
        
        # Handle shop update if provided
        if attributes[:shop].present?
          food.foods_shops.destroy_all
          shop_record = Shop.find_or_create_by(name: attributes[:shop])
          FoodsShop.find_or_create_by(shop: shop_record, food: food)
        end

        # Handle dishes update if provided
        if attributes[:dishes].present?
          food.dishes_foods.destroy_all
          attributes[:dishes].each do |dish_name|
            dish = Dish.find_by(name: dish_name)
            raise Errors::DishNotFoundError.new(dish_name) unless dish
            
            DishesFood.find_or_create_by(dish: dish, food: food)
          end
        end

        food
      end
    end

    private

    def build_converter
      Object.new.extend(DateConverter)
    end
  end
end