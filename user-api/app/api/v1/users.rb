# This module is responsible for User API with version 1.
module V1
  # This class is responsible for User API with version 1.
  class Users < Grape::API
    helpers UserHelper

    resources :users do
      desc 'Get all users', {
        is_array: true,
        success: Entities::V1::UserFormat
      }
      get do
        users = User.all
        present users, with: Entities::V1::UserFormat
      end

      desc 'Get user with bearer token', {
        success: Entities::V1::UserFormat,
        failure: [{ code: 401, message: 'Unauthorized' }]
      }
      get '/current_user' do
        authenticate_user!
        present @current_user, with: Entities::V1::UserFormat
      end

      desc 'Activated the current user', {
        success: [{code: 200, message: 'Activated account successfully'}],
        failure: [{code: 401, message: 'Failed to activate the current user'}]
      }
      params do
        requires :activation_digest, type: String
      end
      get '/activate' do
        find_by_activation_digest!
        @current_user.activate! unless @current_user.activated
        present @current_user, with: Entities::V1::UserFormat
      end

      desc 'Send reset password email', {
        success: [{code: 200, message: 'Send reset password email successfully!'}],
        failure: [{code: 404, message: 'Not found User with email address in data'}]
      }
      params do
        requires :email, regexp: URI::MailTo::EMAIL_REGEXP
      end
      get '/send_reset_password_email' do
        user = User.find_by(email: params[:email])
        error!('404 Not Found', 404) unless user
        error!('Account has not activated', 400) unless user.activated
        user.reset_digest = User.generate_unique_secure_token
        user.reset_sent_at = Time.zone.now
        user.send_reset_password_email
      end

      desc 'Reset password page'
      params do
        requires :reset_digest
      end
      get '/reset_password_page' do
        @user = User.find_by(reset_digest: params[:reset_digest])
        error!('Not found User', 400) unless @user
        error!('Password reset has expired', 410) unless @user.reset_password_expired?
        @user.update_columns!(reset_digest: nil, reset_sent_at: nil)
        # send API change password
      end
    end
  end
end
