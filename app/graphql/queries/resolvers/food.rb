module Queries
    module Resolvers
        class Food < GraphQL::Schema::Resolver
            include DateConverter
            
            type [Types::FoodType], null: false
            description "Foodの詳細情報取得"
            argument :name, String, required: true
            
            def resolve(name:)
                current_user = context[:current_user]
                raise GraphQL::ExecutionError, "Authentication required" unless current_user
                
                food = current_user.foods.find_by(name: name)
                return [] if !food
                _, remain = changeToDate(food.deadline)
                [{
                    name: food.name,
                    remains: remain ? remain : "新たに購入して下さい。",
                    dishes: food.dishes,
                    shops: food.shops
                }]
            end
        end
    end
end