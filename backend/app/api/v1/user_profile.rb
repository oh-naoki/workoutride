module V1
  class UserProfile < Grape::API
    helpers do
      include ::Helpers::AuthHelper
    end

    before do
      authenticate!
    end

    resource :user_profile do
      desc 'ユーザープロフィールを取得'
      get do
        { weight: current_user.weight }
      end

      desc 'ユーザープロフィールを更新'
      params do
        requires :weight, type: Float, desc: '体重 (kg)'
      end
      put do
        unless params[:weight] > 0 && params[:weight] <= 300
          error!('weight must be between 0 and 300', 422)
        end

        current_user.update!(weight: params[:weight])
        { weight: current_user.weight }
      end
    end
  end
end
