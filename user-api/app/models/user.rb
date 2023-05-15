# This class is responsive for Uses Model
class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Activates an account
  def activate!
    update!({ activated: true, activated_at: Time.zone.now })
  end

  # Check account activation
  def activate?
    activated
  end

  def activate_account_expired?
    activated_at < 2.hours.ago
  end

  def reset_password_expired?
    reset_sent_at < 2.hours.ago
  end
end
