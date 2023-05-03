module Types
  class FoodType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :deadline, Integer, null: false
    field :day, String, null: true
    field :remains, String, null: true
    field :price, Integer, null: false
    field :dishes, [Types::DishType], null: false
    field :shops, [Types::ShopType], null: true
  end
end
