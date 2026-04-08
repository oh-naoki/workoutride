class UserFtp < ApplicationRecord
  belongs_to :user, optional: true

  validates :ftp_value, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 2000 }
end
