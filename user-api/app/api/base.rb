# This Base class is responsible for generating all API from multiple versions
class Base < Grape::API
  format :json
  prefix :api

  mount V1::UserApi
end
