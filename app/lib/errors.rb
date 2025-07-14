module Errors
  class BaseError < StandardError
    attr_reader :code, :message

    def initialize(message, code = nil)
      @message = message
      @code = code
      super(message)
    end
  end

  class FoodNotFoundError < BaseError
    def initialize(name)
      super("Food '#{name}' not found", :food_not_found)
    end
  end

  class DishNotFoundError < BaseError
    def initialize(name)
      super("Dish '#{name}' not found", :dish_not_found)
    end
  end

  class FoodAlreadyExistsError < BaseError
    def initialize(name)
      super("Food '#{name}' already exists", :food_already_exists)
    end
  end

  class DishAlreadyExistsError < BaseError
    def initialize(name)
      super("Dish '#{name}' already exists", :dish_already_exists)
    end
  end

  class InvalidDeadlineError < BaseError
    def initialize
      super("Invalid deadline format. Use YYMMDD format", :invalid_deadline)
    end
  end
end