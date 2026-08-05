module V1
  class Root < Grape::API
    version 'v1', using: :path
    format :json
    content_type :json, 'application/json;charset=UTF-8'

    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!({ error: 'Not found' }, 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!({ error: e.record.errors.full_messages.join(', ') }, 422)
    end

    # GrapeのバリデーションエラーやHTTPステータス付き例外は自前の情報を保持しているため、
    # 一段狭いこのハンドラでキャッチしてcatch-all(rescue_from :all)に飲まれないようにする。
    rescue_from Grape::Exceptions::Base do |e|
      error!(e.message, e.status)
    end

    rescue_from :all do |e|
      Rails.logger.error("[API] Unhandled error: #{e.class} - #{e.message}")
      Sentry.capture_exception(e) if defined?(Sentry)
      error!({ error: 'Internal server error' }, 500)
    end

    mount V1::Auth
    mount V1::Workouts
    mount V1::WorkoutResults
    mount V1::UserFtps
    mount V1::UserProfile
  end
end