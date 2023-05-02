module Queries
    module Resolvers
        class Dishes < GraphQL::Schema::Resolver
            type [Types::DishType], null: false
            description "Dishの一覧取得"

            def resolve
                ::Dish.all
            end
        end
    end
end