class Dish < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :dishes_foods, dependent: :destroy
  has_many :foods, through: :dishes_foods
  has_many :recipe_urls, dependent: :destroy

  scope :with_foods, -> { joins(:foods).distinct }
  scope :alphabetical, -> { order(:name) }
end
