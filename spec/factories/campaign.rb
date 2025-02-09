# frozen_string_literal: true

FactoryBot.define do
  factory :campaign do
    title { 'My Campaign' }
    description { 'This is my campaign.' }
    accepted_currencies { ['USDC'] }
    association :repository
    association :receiving_wallet, factory: :wallet
  end
end
