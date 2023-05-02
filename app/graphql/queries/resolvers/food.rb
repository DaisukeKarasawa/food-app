module Queries
    module Resolvers
        class Food < GraphQL::Schema::Resolver
            type [Types::FoodType], null: false
            description "Foodの詳細情報取得"
            argument :name, String, required: true

            def remainDay(year, month, day)
                year = year < 100 ? year + 2000 : year
                yearNow, monthNow, dayNow = Time.now.strftime("%Y-%m-%d").split("-").map(&:to_i)
                limit = (Date.new(year, month, day) - Date.new(yearNow, monthNow, dayNow)).to_i
                limit != 0 ? "#{limit}" : "賞味期限はすでに過ぎてしまいました。"
            end

            def changeToDate(deadline)
                return nil unless deadline.to_s.length == 6
                
                year = deadline / 10000
                month = (deadline % 10000) / 100
                day = deadline % 100
                return "#{year}/#{month}/#{day}", remainDay(year, month, day)
            end
            
            def resolve(name:)
                food = ::Food.find_by(name: name)
                return [] unless food
                deadline, remains = changeToDate(food.deadline)
                foodshops = ::FoodsShop.where(food_id: food.id)
                dishesfood = ::DishesFood.where(food_id: food.id).distinct(:name)
                [{
                    name: food.name,
                    day: deadline,
                    remains: remains,
                    dish: dishesfood,
                    shops: foodshops
                }]
            end
        end
    end
end