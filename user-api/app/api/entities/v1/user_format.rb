# This module is responsible for Format User Json Response
module Entities
  module V1
    class UserFormat < Grape::Entity
      expose :id
      expose :name
      expose :phone
      expose :address
    end
  end
end
