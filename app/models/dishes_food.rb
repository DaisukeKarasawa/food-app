class DishesFood < ApplicationRecord
  belongs_to :dish
  belongs_to :food
end
