module Types
  class DishType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :url, String, null: true
    field :foods, [Types::DishesFoodType], null: true
    field :recipe_urls, [Types::RecipeUrlType], null: true
  end
end