module Queries
    module Resolvers
        class Dishes < GraphQL::Schema::Resolver
            type [Types::DishType], null: false
            description "Dishの一覧取得"

            def resolve
                current_user = context[:current_user]
                raise GraphQL::ExecutionError, "Authentication required" unless current_user
                
                current_user.dishes
            end
        end
    end
end