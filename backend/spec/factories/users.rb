FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "Password123!" }
    password_confirmation { password }

    trait :admin do
      sequence(:username) { |n| "admin_#{n}" }
      sequence(:email) { |n| "admin_#{n}@example.com" }
      role { "admin" }
    end
  end
end
