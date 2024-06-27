# frozen_string_literal: true

class Campaign < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet_id'

  validates :title, presence: { message: 'must be provided and cannot be blank.' }
  validates :accepted_currencies, length: { minimum: 1, message: 'must include at least one currency.' }
  validates :repo_identifier, presence: true, uniqueness: { scope: :user_id, message: 'has already been used for another campaign' }

  scope :by_repo_identifier, ->(identifier) { where(repo_identifier: identifier).first }

  ALL_CURRENCIES = %w[USDC BTC ETH].freeze

  # Optional association indicator for UI logic or elsewhere
  # def repo_centric?
  #   repo_identifier.present?
  # end
end
