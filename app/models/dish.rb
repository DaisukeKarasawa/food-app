class Dish < ApplicationRecord
    has_many :dishes_foods
    has_many :foods, through: :dishes_foods
    has_many :recipe_urls
end
