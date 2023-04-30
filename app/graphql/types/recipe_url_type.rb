module Types
  class RecipeUrlType < Types::BaseObject
    field :id, ID, null: false
    field :url, String, null: false
    field :dish, Types::DishType, null: true
  end
end