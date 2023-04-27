# This module is responsible for User API with version 1.
module V1
  # This class is responsible for User API with version 1.
  class Users < Grape::API
    helpers UserHelper

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
      get '/current_user' do
        authenticate_user!
        present @current_user, with: Entities::V1::UserFormat
      end
    end
  end
end
