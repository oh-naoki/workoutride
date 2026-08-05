# Be sure to restart your server when you modify this file.

# 意図的に未設定: このAPIのクライアントはFlutterアプリ（Android/iOSネイティブ）のみで、
# ブラウザ上のJSから別オリジンとして呼び出す経路（Web版フロントエンド等）は存在しない。
# ネイティブHTTPクライアントはブラウザのSame-Origin Policy/CORSの対象外のため、
# CORS設定なしで問題ない。将来Web版クライアントを追加する場合はここでオリジンを許可する。
#
# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "example.com"
#
#     resource "*",
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end
