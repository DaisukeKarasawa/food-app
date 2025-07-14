module Types
  class FoodType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :deadline, Integer, null: false
    field :day, String, null: true
    field :remains, String, null: true
    field :price, Integer, null: false
    field :dishes, [Types::DishType], null: true
    field :shops, [Types::ShopType], null: false

    def day
      return nil unless object.deadline
      
      converter = Object.new.extend(DateConverter)
      day, _ = converter.changeToDate(object.deadline)
      day
    end

    def remains
      return nil unless object.deadline
      
      converter = Object.new.extend(DateConverter)
      _, remains = converter.changeToDate(object.deadline)
      remains ? "#{remains}日" : "期限切れ"
    end
  end
end
