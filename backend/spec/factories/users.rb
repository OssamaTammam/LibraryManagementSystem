FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { TestConstants::DEFAULT_USER_PARAMS[:password] }
    password_confirmation { password }

    trait :admin do
      sequence(:username) { |n| "admin_#{n}" }
      sequence(:email) { |n| "admin_#{n}@example.com" }
      role { "admin" }
    end
  end
end
