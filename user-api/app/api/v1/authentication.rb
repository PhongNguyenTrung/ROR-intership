# This module is responsible for API with version 1.
module V1
  # This class is responsible for Authentication API with version 1.
  class Authentication < Grape::API
    helpers JwtToken

    desc 'Sign up user', {
      success: Entities::V1::UserFormat,
      failure: [{ code: 400, message: 'Bad request' }]
    }
    params do
      requires :name, type: String, allow_blank: false, documentation: { param_type: 'body' }
      optional :phone, type: String, allow_blank: false, documentation: { param_type: 'body' }
      optional :address, type: String, allow_blank: false, documentation: { param_type: 'body' }
      requires :email, type: String, allow_blank: false, regexp: URI::MailTo::EMAIL_REGEXP, documentation: {
        param_type: 'body'
      }
      requires :password, type: String, allow_blank: false, documentation: {
        param_type: 'body'
      }
      requires :password_confirmation, type: String, allow_blank: false, same_as: :password, documentation: {
        param_type: 'body'
      }
    end
    post '/signup' do
      user = User.create!(params)
      present user, with: Entities::V1::UserFormat
    end

    desc 'Login User', {
      success: Entities::V1::Token,
      failure: [{ code: 401, message: 'Unauthorized' }]
    }
    params do
      requires :email, type: String, allow_blank: false, regexp: URI::MailTo::EMAIL_REGEXP, documentation: {
        param_type: 'body'
      }
      requires :password, type: String, allow_blank: false, documentation: { param_type: 'body' }
    end
    post '/login' do
      user = User.find_by(email: params[:email].downcase)
      if user&.authenticate(params[:password])
        payload = { user_id: user.id }
        token = jwt_encode(payload)
        present token:
      else
        error!('401 Unauthorized', 401)
      end
    end
  end
end
