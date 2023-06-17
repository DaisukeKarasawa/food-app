module Types
  class DishType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :foods, [Types::FoodType], null: true
    field :recipe_urls, [Types::RecipeUrlType], null: true

    def recipe_urls
      Loaders::AssociationLoader.for(Dish, :recipe_urls).load(object)
    end
  end
end