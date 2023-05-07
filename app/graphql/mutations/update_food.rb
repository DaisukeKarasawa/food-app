module Mutations
  class UpdateFood < BaseMutation
    include DateConverter

    field :food, Types::FoodType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :deadline, Integer, required: true
    argument :price, Integer, required: false
    argument :shop, String, required: false

    def resolve(**args)
      errors = []

      begin
        ActiveRecord::Base.transaction do
          # deadline更新
          if args[:deadline].present? && args[:name].present?
            deadline = args[:deadline]
            day, remains = changeToDate(deadline)
            food = Food.find_by(name: args[:name])
            return { food: nil } if !remains || !food

            food.update(deadline: deadline)
          else
            errors << "Both name and deadline are required to update the deadline of a food item."
            raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
          end

          # shopの追加
          if args[:shop].present? && !food.shops.include?(args[:shop])
            shop = Shop.find_or_create_by(name: args[:shop])
            FoodsShop.find_or_create_by(food: food, shop: shop)
          end

          food.update(price: args[:price]) if args[:price].present?

          if food.present? && food.errors.empty?
            {
              food: food,
              errors: []
            }
          else
            {
              food: nil,
              errors: food.errors.full_messages
            }
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        {
          food: nil,
          errors: e.record.errors.full_messages
        }
      end
    end
  end
end