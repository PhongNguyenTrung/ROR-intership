# This class is responsible for sending reset password email
class ResetPasswordEmailSenderService < ApplicationService
  def initialize(user)
    super()
    @user = user
  end

  def call
    send_reset_password_email
  end

  private

  def send_reset_password_email
    raise NotFoundError.new('Not found User with email address', 404) unless @user
    raise InactivatedAccount.new('Account has not activated', 403) unless @user.activate?

    @user.update!({ reset_digest: User.generate_unique_secure_token, reset_sent_at: Time.zone.now })
    UserMailer.password_reset(@user).deliver_now
  end
end
