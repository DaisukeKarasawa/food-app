module Mutations
  class CreateDish < BaseMutation
    include LinkUrls,
            ValidateDishData,
            ValidateFoodsData,
            LinkFoodToDish

    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :recipeUrls, [String], required: false
    argument :foods, [String], required: true

    def resolve(**args)
      return { dish: nil } if Dish.find_by(name: args[:name])

      dish = nil
      errors = []
      action = "create"

      ActiveRecord::Base.transaction do
        dishName = args[:name]

        validateDishData(dishName, action, errors)
        validateFoodsData(args[:foods], action, errors)
        dish = createDish(dishName, errors)
        linkFoodToDish(dish, args[:foods], "Food", errors)
        linkUrls(dish, args[:recipeUrls], errors) if args[:recipeUrls].present?
      end

      if dish.present? && errors.empty?
        {
          dish: dish,
          errors: nil
        }
      else
        raise ActiveRecord::Rollback
        {
          dish: nil,
          errors: errors.presence || ["Failed to create dish"]
        }
      end
    end

    private

    # Dish 作成
    def createDish(name, errors)
      existDish = Dish.find_by(name: name)
      if !existDish.present?
        Dish.create!(name: name)
      else
        errors << "The dish name '#{name}' already exists."
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
      end
    end
  end
end
