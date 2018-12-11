
module API
  module V1
    class Root < Grape::API

      # http://localhost:3000/api/v1/
      # version 'v1'
      version 'v1', using: :path #/v1がパスにつく
      format :json

      mount API::V1::Card_api
      # mount API::V1::Products
    end
  end
end
