FactoryBot.define do
  factory :user do
    provider { 'google' }
    sequence(:uid) { |n| "google-uid-#{n}" }
  end
end
