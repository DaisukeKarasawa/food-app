module Queries
    module Resolvers
        class Foods < GraphQL::Schema::Resolver
            type [Types::FoodType], null: false
            description "Foodの一覧取得"

            def changeToDate(deadline)
                return nil unless deadline.to_s.length == 6
                
                year = deadline / 10000
                month = (deadline % 10000) / 100
                day = deadline % 100
                "#{year}/#{month}/#{day}"
            end

            def resolve
                foods = ::Food.all
                results = foods.map do |food|
                    deadline = changeToDate(food.deadline)
                    {
                        name: food.name,
                        day: deadline
                    }
                end
                results
            end
        end
    end
end