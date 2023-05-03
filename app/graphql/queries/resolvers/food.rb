module Queries
    module Resolvers
        class Food < GraphQL::Schema::Resolver
            include DateConverter
            
            type [Types::FoodType], null: false
            description "Foodの詳細情報取得"
            argument :name, String, required: true
            
            def resolve(name:)
                food = ::Food.find_by(name: name)
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