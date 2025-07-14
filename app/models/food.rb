class Food < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :deadline, presence: true, numericality: { only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  validate :deadline_format_validation

  has_many :dishes_foods, dependent: :destroy
  has_many :dishes, through: :dishes_foods
  has_many :foods_shops, dependent: :destroy
  has_many :shops, through: :foods_shops

  scope :not_expired, -> { 
    where("deadline >= ?", Date.current.strftime("%y%m%d").to_i)
  }

  scope :by_deadline, -> { order(:deadline) }

  private

  def deadline_format_validation
    return unless deadline.present?
    
    deadline_str = deadline.to_s
    unless deadline_str.length == 6 && deadline_str.match?(/^\d{6}$/)
      errors.add(:deadline, "must be in YYMMDD format")
    end
  end
end
