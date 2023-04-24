# This modlue is responsible for
module User
  # This module is responsible for User API
  class API < Graph::API
    version 'v1', using: :header, vendor: 'user'
    format :json
    prefix :api

    resource :users do
      desc 'Get all users'
      get do
        @users = User.all
      end
    end
  end
end
