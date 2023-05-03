class Shop < ApplicationRecord
    has_many :foods_shops
    has_many :foods, through: :foods_shops
end