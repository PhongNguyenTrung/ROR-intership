# This module is responsible for API with version 1.
module V1
  # This class is responsible for Account Activation API with version 1.
  class AccountActivation < Grape::API
    resources :users do
      desc 'Send activation account email', {
        success: [{ code: 200, message: 'Send activation account email successfully' }],
        failure: [{ code: 400, message: 'Account has been activated' },
                  { code: 404, message: 'Not found User with email address' }]
      }
      params do
        requires :email, regexp: URI::MailTo::EMAIL_REGEXP
      end
      get '/send_activation_email' do
        user = User.find_by(email: params[:email])
        error!('Not found User with email address', 404) unless user
        error!('Account has activated', 400) if user.activate?
        user.update!({ activation_digest: User.generate_unique_secure_token, activated_at: Time.zone.now })
        user.send_activation_email
      end

      desc 'Activated the current user', {
        success: [{ code: 200, message: 'Activated account successfully' }],
        failure: [{ code: 400, message: 'Account has been activated' },
                  { code: 401, message: 'Failed to activate the current user' }, { code: 404, message: 'Not Found' }]
      }
      params do
        requires :activation_digest, type: String
      end
      get '/activate' do
        user = User.find_by(activation_digest: params[:activation_digest])
        error!('Not found User! This link is not available now!', 400) unless user
        if user.activate_account_expired?
          error!('Activation Email has expired! Please try again in your email address', 410)
        end
        if user.activate?
          error!('Account has activated', 400)
        else
          user.activate!
        end
        present user, with: Entities::V1::UserFormat
      end
    end
  end
end
