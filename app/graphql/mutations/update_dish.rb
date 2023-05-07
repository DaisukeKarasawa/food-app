module Mutations
  class UpdateDish < BaseMutation
    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :foods, [String], required: true

    def resolve(**args)
      dish = Dish.find_by(name: args[:name])
      return { food: nil } if !dish

      foods = args[:foods]
      foods.each do |food|
        existFood = Food.find_by(name: food)
        if existFood && !dish.foods.include?(food)
          DishesFood.find_or_create_by(food: existFood, dish: dish)
        else
          next
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
