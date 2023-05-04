# This class is responsive for Uses Model
class User < ApplicationRecord
  before_save { email.downcase! }
  # before_create :create_activation_digest
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password
  has_secure_token
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Activates an account
  def activate!
    update_columns!(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Check account activation
  def account_activate?
    
  end

  # Sends reset password email
  def send_reset_password_email
    UserMailer.password_reset(self).deliver_now
  end

  def reset_password_expired?
    reset_sent_at < 2.hours.ago
  end
  private 

end
