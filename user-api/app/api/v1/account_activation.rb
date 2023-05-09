# This module is responsible for API with version 1.
module V1
  # This class is responsible for Account Activation API with version 1.
  class AccountActivation < Grape::API
    rescue_from :all do |e|
      error!({ error: e.class, message: e.message }, e.code)
    end
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
        ActivationEmailSenderService.call(user)
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
        user = ActivateEmailService.call(params)
        present user, with: Entities::V1::UserFormat
      end
    end
  end
end
