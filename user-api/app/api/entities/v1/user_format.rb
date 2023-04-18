module Entities::V1
  class UserFormat < Grape::Entity
    expose :id
    expose :name
    expose :phone
    expose :address
  end
end
