class Root < Grape::API
  prefix 'api'

  # api/v1/root.rbをマウント
  mount V1::Root
end