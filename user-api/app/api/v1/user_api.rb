# This module is responsible for User API with version 1.
module V1
  # This class is responsible for User API with version 1.
  class UserApi < Grape::API
    helpers JwtToken
    helpers do
      def authenticate_user
        header = request.headers['Authorization']
        header = header.split.last if header
        begin
          decoded = jwt_decode(header)
          @current_user = User.find(decoded[:user_id])
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          error!('401 Unauthorized', 401)
        end
      end
    end

    version 'v1', using: :path

    resources :users do
      desc 'Get all users', {
        is_array: true,
        success: Entities::V1::UserFormat,
        failure: [{ code: 401, message: 'Unauthorized' }]
      }
      get do
        users = User.all
        present users, with: Entities::V1::UserFormat
      end

      desc 'Get user with bearer token', {
        success: Entities::V1::UserFormat,
        failure: [{ code: 401, message: 'Unauthorized' }]
      }
      before do
        authenticate_user
      end
      get '/current_user' do
        present @current_user, with: Entities::V1::UserFormat
      end
    end

    desc 'Sign up user', {
      success: Entities::V1::UserFormat,
      failure: [{ code: 400, message: 'Bad request' }]
    }
    params do
      requires :name, type: String, allow_blank: false, documentation: { param_type: 'body' }
      optional :phone, type: String, allow_blank: false, documentation: { param_type: 'body' }
      optional :address, type: String, allow_blank: false, documentation: { param_type: 'body' }
      requires :email, type: String, allow_blank: false, regexp: URI::MailTo::EMAIL_REGEXP, \
        documentation: { param_type: 'body' }
      requires :password, type: String, allow_blank: false, documentation: { param_type: 'body' }
      requires :password_confirmation, type: String, allow_blank: false, same_as: :password, \
        documentation: { param_type: 'body' }
    end
    post '/signup' do
      user = User.new(params)
      error!("400 Bad_Request: #{user.errors.full_messages.join(',')}", 400) unless user.save
      present user, with: Entities::V1::UserFormat
    end

    desc 'Login User', {
      success: Entities::V1::Token,
      failure: [{ code: 401, message: 'Unauthorized' }]
    }
    params do
      requires :email, type: String, allow_blank: false, regexp: URI::MailTo::EMAIL_REGEXP, \
        documentation: { param_type: 'body' }
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
