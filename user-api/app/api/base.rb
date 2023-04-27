# This Base class is responsible for generating all API from multiple versions
class Base < Grape::API
  format :json
  prefix :api
  version 'v1', using: :path

  mount V1::Users
  mount V1::Authentication

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  add_swagger_documentation \
    api_version: 'v1',
    schemes: 'http', # important for testing in local environments
    info: {
      title: 'User API Documentation',
      description: 'User API documentation ver 1 coded by Grape with Grape Entity',
      contact_name: 'Phong Nguyen',
      contact_email: 'phong123@email.com'
    },
    security_definitions: {
      bearerAuth: {
        type: 'apiKey',
        name: 'Authorization',
        in: 'header',
        description: 'Use Bearer authentication token to access the API'
      }
    },
    security: [
      {
        bearerAuth: []
      }
    ],
    models: [
      Entities::V1::UserFormat,
      Entities::V1::Token
    ]
end
