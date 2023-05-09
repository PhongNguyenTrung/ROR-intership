# This class is responsible for sending activation email
class ActivationEmailSenderService < ApplicationService
  def initialize(user)
    super()
    @user = user
  end

  def call
    send_activation_email
  end

  private

  def send_activation_email
    raise NotFoundError.new('Not found User with email address', 404) unless @user
    raise ActivatedError.new('Account has activated', 400) if @user.activate?

    @user.update!({ activation_digest: User.generate_unique_secure_token, activated_at: Time.zone.now })
    UserMailer.account_activation(@user).deliver_now
  end
end
