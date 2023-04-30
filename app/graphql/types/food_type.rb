module Types
  class FoodType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :deadline, Integer, null: false
    field :price, Integer, null: false
    field :dish, [Types::DishType], null: true
    field :shops, [Types::ShopType], null: true
  end
end
