module API
  class Base < Grape::API
    mount V1::UserApi
  end
end
