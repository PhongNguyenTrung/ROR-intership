class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation (user)
    @user = user
    @activation_url = "http://localhost:3000/api/v1/users/activate?activation_digest=#{user.activation_digest}"
    mail to: user.email, subject: 'Account Activation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset (user)
    @user = user
    @password_reset_url = "http://localhost:3000/api/v1/users/reset_password_page?reset_digest=#{user.reset_digest}"
    mail to: user.email, subject: 'Password Reset'
  end
end
