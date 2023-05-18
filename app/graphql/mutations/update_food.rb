module Mutations
  class UpdateFood < BaseMutation
    include DateConverter,
            FindData

    field :food, Types::FoodType, null: true
    field :errors, [String], null: true

    argument :name, String, required: true
    argument :deadline, Integer, required: true
    argument :price, Integer, required: false
    argument :shop, String, required: false

    def resolve(**args)
      food = nil
      errors = []
      action = "Food"

      ActiveRecord::Base.transaction do
        validateFoodData(args, errors)
        food = findData(args[:name], action, errors)
        updateFood(food, args, errors)
        updatePrice(food, args[:price]) if args[:price].present?
        addShop(food, args[:shop]) if args[:shop].present?
      end

      if food.present? && food.errors.empty?
        {
          food: food,
          errors: []
        }
      else
        raise ActiveRecord::Rollback
        {
          food: nil,
          errors: food.errors.full_messages
        }
      end
    end

    private

    # バリデーション
    def validateFoodData(args, errors)
      return if args[:name].present? && args[:deadline].present?

      errors << "Failed to create food. Name and deadline are required."
      raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
    end

    # deadline アップデート
    def updateFood(food, args, errors)
      deadline = args[:deadline]
      day, remains = changeToDate(deadline)

      if remains.present? && food.present?
        food.update(deadline: deadline)
      else
        errors << "Update failed. Please provide a valid deadline for the food."
        raise ActiveRecord::RecordInvalid.new(Food.new), errors.join(", ")
      end
    end

    # price アップデート
    def updatePrice(food, price)
      food.update(price: price)
    end

    # Shop 追加
    def addShop(food, shop)
      if !food.shops.include?(shop)
        shop = Shop.find_or_create_by(name: shop)
        FoodsShop.find_or_create_by(food: food, shop: shop)
      end
    end
  end
end