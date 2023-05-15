# This module is responsible for Format Token Json Response
module Entities
  module V1
    # This class is responsible for Format Token Json Response
    class Token < Grape::Entity
      expose :token
    end
  end
end
