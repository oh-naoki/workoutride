module V1
  class UserFtps < Grape::API
    helpers do
      include ::Helpers::AuthHelper
    end

    before do
      authenticate!
    end

    resource :user_ftps do
      desc '現在のFTPを取得'
      get :current do
        ftp = current_user.user_ftps.order(created_at: :desc).first
        if ftp
          present ftp, with: Entities::UserFtp
        else
          status 404
          { error: 'FTP not found' }
        end
      end

      desc 'FTPを保存'
      params do
        requires :ftp_value, type: Integer, desc: 'FTP値 (W)'
      end
      post do
        ftp = current_user.user_ftps.create!(ftp_value: params[:ftp_value])
        status 201
        present ftp, with: Entities::UserFtp
      end
    end
  end
end
