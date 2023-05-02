module Queries
    module Resolvers
        class Foods < GraphQL::Schema::Resolver
            include DateConverter

            type [Types::FoodType], null: false
            description "Foodの一覧取得"

            def resolve
                foods = ::Food.all
                results = foods.map do |food|
                    day, remain = changeToDate(food.deadline)
                    if remain
                        {
                            name: food.name,
                            day: day
                        }
                    end
                end.compact
                results
            end
        end
    end
end