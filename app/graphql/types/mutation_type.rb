module Types
  class MutationType < Types::BaseObject
    field :create_dish, mutation: Mutations::CreateDish
    field :create_url, mutation: Mutations::CreateUrl
    field :create_food, mutation: Mutations::CreateFood
  end
end
