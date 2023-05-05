module Mutations
  class CreateFood < BaseMutation
    field :food, Types::FoodType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :deadline, Integer, required: true
    argument :price, Integer, required: true
    argument :dishes, [String], required: false
    argument :shops, [String], required: true

    def resolve(**args)
      return { food: nil } if Food.find_by(name: args[:name])
      # Food作成
      food = Food.create(name: args[:name], deadline: args[:deadline], price: args[:price])

      # Dish作成とFoodとの紐付け
      if args[:dishes]
        args[:dishes].each do |dishName|
          if !Dish.find_by(name: dishName)
            dish = Dish.create(name: dishName)
            dish.foods << food
            DishesFood.find_or_create_by(dish: dish, food: food)
          end
        end
      end

      # Shop作成とFoodとの紐付け
      args[:shops].each do |shopName|
        shop = Shop.find_or_create_by(name: shopName)
        shop.foods << food
        FoodsShop.find_or_create_by(shop: shop, food: food)
      end

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
