module FindData
    def findData(name, action, errors)
        access = action == "Food"
        exist = access ? Food.find_by(name: name) : Dish.find_by(name: name)
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