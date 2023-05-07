module Mutations
  class CreateDish < BaseMutation
    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :recipeUrls, [String], required: false
    argument :foods, [String], required: true

    def resolve(**args)
      return { dish: nil } if Dish.find_by(name: args[:name])

      dish = nil
      errors = []

      ActiveRecord::Base.transaction do
        # Dish作成
        if args[:name].present?
          dish = Dish.create(name: args[:name])
        else
          errors << "Failed to create dish. Name or foods are required."
          raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
        end

        # Food作成とDishとの紐付け
        if args[:foods].present?
          args[:foods].each do |food|
            existFood = Food.find_by(name: food)
            if existFood
              DishesFood.find_or_create_by(dish: dish, food: existFood)
            else
              errors << "Food '#{dish}' not found"
              raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
            end
          end
        end

        # RecipeUrl作成とDishとの紐付け
        if args[:recipeUrls].present?
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
      end

      if dish.present? && errors.empty?
        {
          dish: dish,
          errors: errors
        }
      else
        raise ActiveRecord::Rollback
        {
          dish: nil,
          errors: errors.presence || ["Failed to create dish"]
        }
      end
    end
  end
end
