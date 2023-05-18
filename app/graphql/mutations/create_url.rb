module Mutations
  class CreateUrl < BaseMutation
    include LinkUrls

    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :recipeUrls, [String], required: true
    argument :name, String, required: true

    def resolve(**args)
      dish = nil
      errors = []

      validateUrlData(args, errors)
      validateDishData(args, errors)
      dish = findDish(args[:name], errors)
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

    def validateDishData(args, errors)
      return if args[:name].present?

      errors << "Dish can't be blank."
      raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
    end

    # Dish アクセス
    def findDish(dish, errors)
      existDish = Dish.find_by(name: dish)
      if existDish.present?
        return existDish
      else
        errors << "Dish '#{dish}' not found"
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
      end
    end
  end
end
