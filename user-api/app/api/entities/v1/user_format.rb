# This module is responsible for Format User Json Response
module Entities
  module V1
    # This class is responsible for Format User Json Response
    class UserFormat < Grape::Entity
      expose :id
      expose :name
      expose :email
      expose :phone
      expose :address
    end
  end
end
