module Mutations
  class CreateFood < BaseMutation
    include DateConverter
    
    field :food, Types::FoodType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :deadline, Integer, required: true
    argument :price, Integer, required: true
    argument :dishes, [String], required: false
    argument :shop, String, required: true

    def resolve(**args)
      return { food: nil } if Food.find_by(name: args[:name])

      food = nil
      errors = []

      ActiveRecord::Base.transaction do
        validateFoodData(args, errors)
        food = createFood(args[:name], args[:deadline], args[:price])
        linkDishes(food, args[:dishes], errors) if args[:dishes].present?
        linkShop(food, args[:shop], errors)
      end
      
      if food.present? && errors.empty?
        {
          food: food,
          errors: nil
        }
      else
        raise ActiveRecord::Rollback
        {
          food: nil,
          errors: errors.presence || ["Failed to create food"]
        }
      end
    end

    private
    
    # バリデーション
    def validateFoodData(args, errors)
      return if args[:name].present? && args[:deadline].present? && args[:price].present?

      errors << "Failed to create food. Name, deadline, and price are required."
      raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
    end

    # Food 作成
    def createFood(name, deadline, price)
      day, remains = changeToDate(deadline)
      raise ActiveRecord::RecordInvalid.new(Food.new), "Invalid deadline." unless remains

      Food.create!(name: name, deadline: deadline, price: price)
    end

    # Food と Dish の紐づけ
    def linkDishes(food, dishes, errors)
      dishes.each do |dish|
        existDish = Dish.find_by(name: dish)
        if existDish.present?
          DishesFood.find_or_create_by(dish: existDish, food: food)
        else
          errors << "Dish '#{dish}' not found"
          raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
        end
      end
    end

    # Food と Shop の紐づけ
    def linkShop(food, shopName, errors)
      if shopName.present?
        newShop = Shop.find_or_create_by(name: shopName)
        FoodsShop.find_or_create_by(shop: newShop, food: food)
      else
        errors << "Shop can't be blank."
        raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
      end
    end
  end
end
