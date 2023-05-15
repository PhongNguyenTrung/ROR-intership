# This class is responsible for activating account
class ActivateEmailService < ApplicationService
  def initialize(params)
    super()
    @activation_digest = params[:activation_digest]
  end

  def call
    activate_email
  end

  private

  def activate_email
    user = User.find_by(activation_digest: @activation_digest)
    raise NotFoundError.new('Not found User! This link is not available now', 404) unless user
    if user.activate_account_expired?
      raise GoneError.new('Activation Email has expired! Please try again in your email address', 410)
    end
    raise ActivatedError.new('Account has activated', 400) if user.activate?

    user.activate!
    user
  end
end
