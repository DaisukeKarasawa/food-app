module LinkFoodToDish
    def linkFoodToDish(main, arr, link, errors)
        action = link == 'Dish'
        arr.each do |ele|
            existEle = action ? Dish.find_by(name: ele) : Food.find_by(name: ele)
            if existEle && action
                DishesFood.find_or_create_by(dish: existEle, food: main)
            elsif existEle && !action
                DishesFood.find_or_create_by(dish: main, food: existEle)
            else
                errors << "#{link} '#{ele}' not found."
                raise ActiveRecord::RecordInvalid.new(DishesFood.new), errors.join(", ")
            end
        end
    end
end