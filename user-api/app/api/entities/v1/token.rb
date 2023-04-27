# This module is responsible for Format Token Json Response
module Entities
  module V1
    class Token < Grape::Entity
      expose :token
    end
  end
end
