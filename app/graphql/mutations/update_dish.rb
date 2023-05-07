module Mutations
  class UpdateDish < BaseMutation
    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :foods, [String], required: true

    def resolve(**args)
      dish = nil
      errors = []

      ActiveRecord::Base.transaction do
        if args[:name] && args[:foods]
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
        else
          errors << "Name can't be blank, Foods can't be blank"
          raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
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
