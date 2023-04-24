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
          @decoded = jwt_decode(header)
          @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          error!('Unauthorized', 401)
        end
      end
    end

    version 'v1', using: :path
    resource :users do
      desc 'Get all users'
      get '/get_all_users' do
        @users = User.all
        present @users, with: Entities::V1::UserFormat
      end

      desc 'Sign up user'
      params do
        requires :name, type: String, allow_blank: false
        optional :phone, type: String, allow_blank: false
        optional :address, type: String, allow_blank: false
        requires :email, type: String, allow_blank: false, regexp: URI::MailTo::EMAIL_REGEXP
        requires :password, type: String, allow_blank: false
        requires :password_confirmation, type: String, allow_blank: false, same_as: :password
      end
      post '/signup' do
        user = User.new(declared(params))
        error!('400 Bad_Request', 400) unless user.save
        present user, with: Entities::V1::UserFormat
      end

      desc 'Login User'
      params do
        requires :email, type: String, allow_blank: false, regexp: URI::MailTo::EMAIL_REGEXP
        requires :password, type: String, allow_blank: false
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

      desc 'Get user with bearer token'
      before do
        authenticate_user
      end
      get '/current_user' do
        present @current_user, with: Entities::V1::UserFormat
      end
    end
  end
end
