module Mutations
  class UpdateDish < BaseMutation
    include ValidateDishData,
            ValidateFoodsData,
            FindData

    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :foods, [String], required: true

    def resolve(**args)
      current_user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless current_user
      
      dish = nil
      errors = []
      action = "update"

      ActiveRecord::Base.transaction do
        dishName = args[:name]
        action = "Dish"

        validateDishData(dishName, action, errors)
        validateFoodsData(args[:foods], action, errors)
        dish = findData(dishName, action, errors, current_user)
        linkFoods(dish, args[:foods], errors, current_user)
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

    private

    # Dish と Food の紐付け
    def linkFoods(dish, foods, errors, user)
      foods.each do |food|
        existFood = user.foods.find_by(name: food)
        if existFood.present? && !dish.foods.include?(food)
          DishesFood.find_or_create_by(food: existFood, dish: dish)
        else
          next
        end
      end
    end
  end
end
