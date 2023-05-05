module Mutations
  class CreateDish < BaseMutation
    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :recipeUrls, [String], required: false
    argument :foods, [String], required: true

    def resolve(**args)
      return { dish: nil } if Dish.find_by(name: args[:name])
      # Dish作成
      dish = Dish.create(name: args[:name])

      # Food作成とDishとの紐付け
      foodList = args[:foods].map do |food|
        Food.find_by(name: food)
      end.compact

      dish.foods = foodList
      DishesFood.find_or_create_by(dish: dish, food: foodList)

      # RecipeUrl作成とDishとの紐付け
      if args[:recipeUrls]
        args[:recipeUrls].each do |url|
          if !RecipeUrl.find_by(url: url)
            newUrl = RecipeUrl.create(url: url)
            newUrl.dish = dish
            dish.recipe_urls << newUrl
          else
            next
          end
        end
      end

      if dish.errors.empty?
        {
          dish: dish,
          errors: []
        }
      else
        {
          dish: nil,
          errors: dish.errors.full_messages
        }
      end
    end
  end
end
