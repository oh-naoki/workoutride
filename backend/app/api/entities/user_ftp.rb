module Entities
  class UserFtp < Grape::Entity
    expose :id
    expose :ftp_value
    expose :created_at
    expose :updated_at
  end
end
