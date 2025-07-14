module FoodConstants
  DEADLINE_FORMAT = /^\d{6}$/
  DEADLINE_LENGTH = 6
  
  # Error messages
  MESSAGES = {
    food_not_found: "Food '%{name}' not found",
    dish_not_found: "Dish '%{name}' not found",
    food_already_exists: "Food '%{name}' already exists",
    dish_already_exists: "Dish '%{name}' already exists",
    invalid_deadline: "Invalid deadline format. Use YYMMDD format",
    expired_food: "期限切れ",
    purchase_required: "新たに購入して下さい。"
  }.freeze
end