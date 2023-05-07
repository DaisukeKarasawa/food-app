module Mutations
  class CreateUrl < BaseMutation
    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :recipeUrls, [String], required: true
    argument :name, String, required: true

    def resolve(**args)
      dish = nil
      errors = []

      if args[:recipeUrls].present? && args[:name].present?
        dish = Dish.find_by(name: args[:name])
      else
        errors << "Name is required to search for recipes."
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
      end

      if !dish.present?
        errors << "Dish with name '#{args[:name]}' not found"
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
      end

      # RecipeUrl作成とDishとの紐付け
      args[:recipeUrls].each do |url|
        if !RecipeUrl.find_by(url: url)
          RecipeUrl.create(url: url, dish: dish)
        else
          next
        end
      end
      {
        dish: dish,
        errors: errors
      }
    end
  end
end
