# This class is responsible for generating method sending messages
class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    @activation_url = "http://localhost:3000/api/v1/users/activate?activation_digest=#{user.activation_digest}"
    @resend_activation_url = "http://localhost:3000/api/v1/users/send_activation_email?email=#{user.email}"
    mail to: user.email, subject: t(:account_activation)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    @password_reset_url = "http://localhost:3000/api/v1/users/reset_password_page?reset_digest=#{user.reset_digest}"
    @resend_password_reset_url = "http://localhost:3000/api/v1/users/send_reset_password_email?email=#{user.email}"
    mail to: user.email, subject: t(:reset_password)
  end
end
