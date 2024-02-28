# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    address { Faker::Blockchain::Ethereum.address } # Using Faker to generate a random Ethereum address
    chain_id { 1 }
    user
  end
end
