# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    address { Faker::Blockchain::Ethereum.address }
    association :user
  end
end
