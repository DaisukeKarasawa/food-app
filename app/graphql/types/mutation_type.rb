module Types
  class MutationType < Types::BaseObject
    field :update_dish, mutation: Mutations::UpdateDish
    field :update_food, mutation: Mutations::UpdateFood
    field :create_dish, mutation: Mutations::CreateDish
    field :create_url, mutation: Mutations::CreateUrl
    field :create_food, mutation: Mutations::CreateFood
  end
end
