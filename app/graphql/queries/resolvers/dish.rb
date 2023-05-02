module Queries
    module Resolvers
        class Dish < GraphQL::Schema::Resolver
            type [Types::DishType], null: false
            description "Dishの詳細情報取得"
            argument :name, String, required: true

            def resolve(name:)
                dishes = ::Dish.where(name: name)
                results = dishes.map do |dish|
                    urls = ::RecipeUrl.where(dish_id: dish.id)
                    {
                        name: dish.name,
                        recipe_urls: urls
                    }
                end
                results
            end
        end
    end
end