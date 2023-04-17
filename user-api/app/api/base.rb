require 'grape'
class Base < Grape::API
  format :json
  prefix :api
  mount V1::UserApi
end

