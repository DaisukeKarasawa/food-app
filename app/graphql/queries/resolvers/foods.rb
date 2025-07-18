module Queries
    module Resolvers
        class Foods < GraphQL::Schema::Resolver
            include DateConverter

            type [Types::FoodType], null: false
            description "Foodの一覧取得"

            def resolve
                current_user = context[:current_user]
                raise GraphQL::ExecutionError, "Authentication required" unless current_user
                
                foods = current_user.foods
                # Filter out expired foods
                foods.select do |food|
                    day, remain = changeToDate(food.deadline)
                    remain # Only include foods that are still valid
                end
            end
        end
    end
end