class DishService
  class << self
    def list_all_dishes
      Dish.includes(:foods, :recipe_urls).all
    end

    def find_dish_by_name(name)
      dish = Dish.includes(:foods, :recipe_urls).find_by(name: name)
      return nil unless dish

      {
        id: dish.id,
        name: dish.name,
        foods: dish.foods,
        recipe_urls: dish.recipe_urls
      }
    end

    def create_dish(name:, foods: [], recipe_urls: [])
      raise ArgumentError, "Dish '#{name}' already exists" if Dish.exists?(name: name)

      ActiveRecord::Base.transaction do
        dish = Dish.create!(name: name)

        # Link to foods if provided
        if foods.present?
          foods.each do |food_name|
            food = Food.find_by(name: food_name)
            raise ArgumentError, "Food '#{food_name}' not found" unless food
            
            DishesFood.find_or_create_by(dish: dish, food: food)
          end
        end

        # Create recipe URLs if provided
        if recipe_urls.present?
          recipe_urls.each do |url|
            RecipeUrl.create!(dish: dish, url: url)
          end
        end

        dish
      end
    end

    def update_dish(name:, **attributes)
      dish = Dish.find_by(name: name)
      raise ArgumentError, "Dish '#{name}' not found" unless dish

      ActiveRecord::Base.transaction do
        dish.update!(attributes.slice(:name))
        
        # Handle foods update if provided
        if attributes[:foods].present?
          dish.dishes_foods.destroy_all
          attributes[:foods].each do |food_name|
            food = Food.find_by(name: food_name)
            raise ArgumentError, "Food '#{food_name}' not found" unless food
            
            DishesFood.find_or_create_by(dish: dish, food: food)
          end
        end

        # Handle recipe URLs update if provided
        if attributes[:recipe_urls].present?
          dish.recipe_urls.destroy_all
          attributes[:recipe_urls].each do |url|
            RecipeUrl.create!(dish: dish, url: url)
          end
        end

        dish
      end
    end
  end
end