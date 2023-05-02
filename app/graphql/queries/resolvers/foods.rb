module Queries
    module Resolvers
        class Foods < GraphQL::Schema::Resolver
            type [Types::FoodType], null: false
            description "Foodの一覧取得"

            def resolve
                ::Food.all
            end
        end
    end
end