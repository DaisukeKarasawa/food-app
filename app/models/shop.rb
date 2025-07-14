class Shop < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :foods_shops, dependent: :destroy
  has_many :foods, through: :foods_shops

  scope :alphabetical, -> { order(:name) }
end