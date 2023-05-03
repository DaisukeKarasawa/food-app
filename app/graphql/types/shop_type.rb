module Types
  class ShopType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :foods, [Types::FoodType], null: true
  end
end