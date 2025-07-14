module Mutations
  class UpdateDish < BaseMutation
    field :dish, Types::DishType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :foods, [String], required: false
    argument :recipe_urls, [String], required: false

    def resolve(**args)
      dish = DishService.update_dish(
        name: args[:name],
        foods: args[:foods],
        recipe_urls: args[:recipe_urls]
      )

      {
        dish: dish,
        errors: nil
      }
    rescue ArgumentError => e
      {
        dish: nil,
        errors: [e.message]
      }
    rescue ActiveRecord::RecordInvalid => e
      {
        dish: nil,
        errors: e.record.errors.full_messages
      }
    rescue StandardError => e
      {
        dish: nil,
        errors: ["Failed to update dish: #{e.message}"]
      }
    end
  end
end
