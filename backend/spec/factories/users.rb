FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "Password123!" }
    password_confirmation { password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    # Traits for different user types/states
    trait :admin do
      sequence(:username) { |n| "admin_#{n}" }
      sequence(:email) { |n| "admin_#{n}@example.com" }
      role { "admin" }
      # Additional admin-specific attributes
    end
  end
end
