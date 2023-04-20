# This class is responsive for Uses Model
class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
