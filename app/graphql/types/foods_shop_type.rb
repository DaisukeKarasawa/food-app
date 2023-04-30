module Types
  class FoodsShopType < Types::BaseObject
    field :id, ID, null: false
    field :food, Types::FoodType, null: false
    field :shop, Types::ShopType, null: false
  end
end