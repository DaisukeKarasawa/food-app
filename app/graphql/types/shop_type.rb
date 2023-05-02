module Types
  class ShopType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :foods, [Types::FoodsShopType], null: true
  end
end