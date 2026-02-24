module V1
  class Root < Grape::API
    version 'v1', using: :path
    format :json
    content_type :json, 'application/json;charset=UTF-8'

    mount V1::Auth
    mount V1::Workouts
    mount V1::WorkoutResults
    mount V1::UserFtps
  end
end