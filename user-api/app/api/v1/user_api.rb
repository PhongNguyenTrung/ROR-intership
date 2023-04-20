# This modlue is responsible for
module V1
  # This modlue is responsible for User API
  class UserApi < Graph::API
    version 'v1', using: :path

    resource :users do
      desc 'Get all users'

      get do
        @users = User.all

        present @user, with: Entities::V1::UserFormat
      end
    end
  end
end
