module ValidateDishData
    def validateDishData(dish, action, errors)
        return if dish.present?

        errorMessage = if action == "createUrl"
                            "Dish can't be blank."
                        else
                            "Failed to #{action} dish. Dish is required."
                        end
        errors << errorMessage
        raise ActiveRecord::RecordInvalid.new(Dish.new), errors.join(", ")
    end
end
