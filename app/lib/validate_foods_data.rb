module ValidateFoodsData
    def validateFoodsData(foods, action, errors)
        return if foods.present?

        errors << "Failed to #{action} dish. Food is required."
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
    end
end