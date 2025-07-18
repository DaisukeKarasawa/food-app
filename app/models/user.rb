class User < ApplicationRecord
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  
  has_many :foods, dependent: :destroy
  has_many :dishes, dependent: :destroy
  
  def generate_jwt
    JWT.encode({ user_id: id }, Rails.application.secret_key_base, 'HS256')
  end
  
  def self.decode_jwt(token)
    decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
    user_id = decoded[0]['user_id']
    User.find(user_id)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end
end
