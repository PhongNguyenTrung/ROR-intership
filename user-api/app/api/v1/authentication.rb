# This module is responsible for API with version 1.
module V1
  # This class is responsible for Authentication API with version 1.
  class Authentication < Grape::API
    helpers JwtToken

    rescue_from :all do |e|
      error!({ error: e.class, message: e.message }, e.code)
    end

    desc 'Sign up user', {
      success: Entities::V1::UserFormat,
      failure: [{ code: 400, message: 'Bad request' }]
    }
    params do
      with(type: String, allow_blank: false, documentation: { param_type: 'body' }) do
        requires :name,
                 values: { value: ->(v) { v.length.between?(3, 50) }, message: 'must contains 3-50 characters' }
        optional :phone
        optional :address
        requires :email,
                 regexp: URI::MailTo::EMAIL_REGEXP,
                 values: {
                   value: ->(v) { v.length <= 255 },
                   message: 'contains maximum 255 characters'
                 }
        requires :password
        requires :password_confirmation, same_as: :password
      end
    end
    post '/signup' do
      user = User.create!(params)
      ActivationEmailSenderService.call(user)
      present user, with: Entities::V1::UserFormat
    end

    desc 'Login User', {
      success: Entities::V1::Token,
      failure: [{ code: 401, message: 'Unauthorized' }, { code: 403, message: 'Account has not activated' }]
    }
    params do
      with(type: String, allow_blank: false, documentation: { param_type: 'body' }) do
        requires :email, regexp: URI::MailTo::EMAIL_REGEXP
        requires :password
      end
    end
    post '/login' do
      user = User.find_by(email: params[:email].downcase)
      error!('Account has not activated', 403) unless user.activate?
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
