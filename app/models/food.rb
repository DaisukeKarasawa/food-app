class Food < ApplicationRecord
    has_many :dishes_foods
    has_many :dishes, through: :dishes_foods
    has_many :foods_shops
    has_many :shops, through: :foods_shops
end
