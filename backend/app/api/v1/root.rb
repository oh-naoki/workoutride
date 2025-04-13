module V1
  class Root < Grape::API
    version 'v1', using: :path
    format :json
    content_type :json, 'application/json;charset=UTF-8'

    mount V1::Workouts
  end
end