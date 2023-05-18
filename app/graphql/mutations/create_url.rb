module Mutations
  class CreateUrl < BaseMutation
    include LinkUrls,
            ValidateDishData,
            FindData

    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :recipeUrls, [String], required: true
    argument :name, String, required: true

    def resolve(**args)
      dish = nil
      errors = []
      validateAction = "createUrl"
      findAction = "Dish"
      dishName = args[:name]

      validateUrlData(args, errors)
      validateDishData(dishName, validateAction, errors)
      dish = findData(dishName, findAction, errors)
      linkUrls(dish, args[:recipeUrls], errors)

      if dish.present? && errors.empty?
        {
          dish: dish,
          errors: nil
        }
      else
        raise ActiveRecord::Rollback
        {
          dish: nil,
          errors: errors.presence || ["Failed to create url"]
        }
      end
    end

    private

    # バリデーション
    def validateUrlData(args, errors)
      return if args[:recipeUrls].present?

      errors << "URL is required to search for recipes."
      raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
    end
  end
end
