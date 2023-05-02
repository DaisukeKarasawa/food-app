module Types
  class DishesFoodType < Types::BaseObject
    field :id, ID, null: false
    field :dish, Types::DishType, null: false
    field :food, Types::FoodType, null: false
  end
end
