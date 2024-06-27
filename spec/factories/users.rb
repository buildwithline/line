# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password' }
    provider { 'github' }
    uid { Faker::Number.unique.number(digits: 10).to_s }
  end
end
