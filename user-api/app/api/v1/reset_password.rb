# This module is responsible for API with version 1.
module V1
  # This class is responsible for Authentication API with version 1.
  class ResetPassword < Grape::API
    resources :users do
      desc 'Send reset password email', {
        success: [{ code: 200, message: 'Send reset password email successfully' }],
        failure: [{ code: 404, message: 'Not found User with email address' },
                  { code: 403, message: 'Account has not activated' }]
      }
      params do
        requires :email, regexp: URI::MailTo::EMAIL_REGEXP
      end
      get '/send_reset_password_email' do
        user = User.find_by(email: params[:email])
        error!('Not found User with email address', 404) unless user
        error!('Account has not activated', 403) unless user.activate?
        user.update!({ reset_digest: User.generate_unique_secure_token, reset_sent_at: Time.zone.now })
        user.send_reset_password_email
      end

      desc 'Reset password page'
      params do
        requires :reset_digest
      end
      get '/reset_password_page' do
        user = User.find_by(reset_digest: params[:reset_digest])
        error!('Not found User! This link is not available now!', 400) unless user
        error!('Password reset has expired! Resent Forget Password Email!', 410) if user.reset_password_expired?
      end

      desc 'Reset password'
      params do
        requires :reset_digest
        with(type: String, allow_blank: false, documentation: { param_type: 'body' }) do
          requires :password
          requires :password_confirmation, same_as: :password
        end
      end
      put '/reset_password' do
        user = User.find_by(reset_digest: params[:reset_digest])
        error!('Not found User! This link is not available now!', 400) unless user
        error!('Password reset has expired! Resent Forget Password Email!', 410) if user.reset_password_expired?
        user.update!({ reset_digest: nil, reset_sent_at: nil, password: params[:password],
                       password_confirmation: params[:password_confirmation] })
      end
    end
  end
end
