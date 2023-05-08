# This module is responsible for User API with version 1.
module V1
  # This class is responsible for User API with version 1.
  class V1Base < Grape::API
    version 'v1', using: :path

    mount Users
    mount Authentication
    mount AccountActivation
    mount ResetPassword
  end
end
