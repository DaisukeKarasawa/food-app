class RecipeUrl < ApplicationRecord
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :dish_id, presence: true

  belongs_to :dish
end
