module Queries
    module Resolvers
        class Dish < GraphQL::Schema::Resolver
            type [Types::DishType], null: false
            description "Dishの詳細情報取得"
            argument :name, String, required: true

            def resolve(name:)
                current_user = context[:current_user]
                raise GraphQL::ExecutionError, "Authentication required" unless current_user
                
                dishes = current_user.dishes.where(name: name)
                return [] if !dishes
                results = dishes.map do |dish|
                    {
                        name: dish.name,
                        recipe_urls: dish.recipe_urls,
                        foods: dish.foods
                    }
                end
                results
            end
        end
    end
end