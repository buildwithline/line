# frozen_string_literal: true

class Campaign < ApplicationRecord
  # Associations
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet_id'
  belongs_to :repository

  # Validations
  validates :title, presence: { message: 'must be provided and cannot be blank.' }
  validates :description, presence: { message: 'must be provided and cannot be blank.' }
  validates :accepted_currencies, length: { minimum: 1, message: 'must include at least one currency.' }

  # Constants
  ALL_CURRENCIES = %w[USDC BTC ETH].freeze

  # Optional association indicator for UI logic or elsewhere
  # def repo_centric?
  #   repo_identifier.present?
  # end
end
