require 'rails_helper'

RSpec.describe UserFtp, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:ftp_value) }
    it { should validate_numericality_of(:ftp_value).is_greater_than(0).is_less_than_or_equal_to(2000) }
  end
end
