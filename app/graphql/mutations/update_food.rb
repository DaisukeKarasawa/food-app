module Mutations
  class UpdateFood < BaseMutation
    field :food, Types::FoodType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :deadline, Integer, required: false
    argument :price, Integer, required: false
    argument :dishes, [String], required: false
    argument :shop, String, required: false

    def resolve(**args)
      food = FoodService.update_food(
        name: args[:name],
        deadline: args[:deadline],
        price: args[:price],
        dishes: args[:dishes],
        shop: args[:shop]
      )

      {
        food: food,
        errors: nil
      }
    rescue ArgumentError => e
      {
        food: nil,
        errors: [e.message]
      }
    rescue ActiveRecord::RecordInvalid => e
      {
        food: nil,
        errors: e.record.errors.full_messages
      }
    rescue StandardError => e
      {
        food: nil,
        errors: ["Failed to update food: #{e.message}"]
      }
    end
  end
end