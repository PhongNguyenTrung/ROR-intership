module Entities::V1
  class UserFormat < Grape::Entity
    expose :id
    expose :name
    expose :phong
    expose :address
  end
end
