module Mutations
  class CreateDish < BaseMutation
    include LinkUrls

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
        validateDishData(args, errors)
        dish = createDish(args[:name])
        linkFoods(dish, args[:foods], errors)
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

    # バリデーション
    def validateDishData(args, errors)
      return if args[:name].present?

      errors << "Failed to create dish. Name is required."
      raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
    end

    # Dish 作成
    def createDish(name)
      Dish.create!(name: name)
    end

    # Dish と Food の紐づけ
    def linkFoods(dish, foods, errors)
      if foods.present?
        foods.each do |food|
          existFood = Food.find_by(name: food)
          if existFood
            DishesFood.find_or_create_by(dish: dish, food: existFood)
          else
            errors << "Food '#{food}' not found"
            raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
          end
        end
      else
        errors << "Food can't be blank."
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
      end
    end
  end
end
