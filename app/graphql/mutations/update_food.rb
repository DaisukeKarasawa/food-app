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
      deadline = args[:deadline]
      day, remains = changeToDate(deadline)
      food = Food.find_by(name: args[:name])
      return { food: nil } if !remains || !food

      food.update(deadline: deadline)

      if args[:shop] && !food.shops.include?(args[:shop])
        shop = Shop.find_or_create_by(name: args[:shop])
        FoodsShop.find_or_create_by(food: food, shop: shop)
      end

      food.update(price: args[:price]) if args[:price]

      if food.errors.empty?
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
  end
end
