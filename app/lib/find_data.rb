module FindData
    def findData(name, action, errors, user = nil)
        access = action == "Food"
        if user.present?
            exist = access ? user.foods.find_by(name: name) : user.dishes.find_by(name: name)
        else
            exist = access ? Food.find_by(name: name) : Dish.find_by(name: name)
        end
        
        if exist.present?
            exist
        elsif access
            errors << "Food '#{name}' not found"
            raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
        else
            errors << "Dish '#{name}' not found"
            raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
        end
    end
end