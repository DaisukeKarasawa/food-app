module Mutations
  class CreateFood < BaseMutation
    field :food, Types::FoodType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :deadline, Integer, required: true
    argument :price, Integer, required: true
    argument :dishes, [String], required: false
    argument :shop, String, required: true

    def resolve(**args)
      return { food: nil } if Food.find_by(name: args[:name])

      food = nil
      errors = []

      ActiveRecord::Base.transaction do
        # Food作成
        if args[:name].present? && args[:deadline].present? && args[:price].present?
          food = Food.create(name: args[:name], deadline: args[:deadline], price: args[:price])
        else
          errors << "Failed to create food. Name, deadline, and price are required."
          raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
        end

        # Dish作成とFoodとの紐付け
        if args[:dishes].present?
          args[:dishes].each do |dish|
            existDish = Dish.find_by(name: dish)
            if existDish
              DishesFood.find_or_create_by(dish: existDish, food: food)
            else
              errors << "Dish '#{dish}' not found"
              raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
            end
          end
        end

        # Shop作成とFoodとの紐付け
        if args[:shop].present?
          newShop = Shop.find_or_create_by(name: args[:shop])
          FoodsShop.find_or_create_by(shop: newShop, food: food)
        else
          errors << "Shop can't be blank."
          raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
        end

      end
      
      if food.present? && errors.empty?
        {
          food: food,
          errors: errors
        }
      else
        raise ActiveRecord::Rollback
        {
          food: nil,
          errors: errors.presence || ["Failed to create food"]
        }
      end
    end
  end
end
