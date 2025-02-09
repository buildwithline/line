# frozen_string_literal: true

class Campaign < ApplicationRecord
  #  Callbacks
  before_save :process_accepted_currencies

  # Associations
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet_id'
  belongs_to :repository

  # Validations
  validates :title, presence: { message: 'must be provided and cannot be blank.' }
  validates :accepted_currencies, length: { minimum: 1, message: 'must include at least one currency.' }, if: -> { accepted_currencies.present? }
  validates :repository_id, uniqueness: { message: 'A campaign for this repository already exists' }

  # Constants
  ALL_CURRENCIES = %w[USDC BTC ETH].freeze

  # Optional association indicator for UI logic or elsewhere
  # def repo_centric?
  #   repo_identifier.present?
  # end

  private

  def process_accepted_currencies
    puts "accepted_currencies class: #{accepted_currencies.class}"
    puts "Accepted currencies before processing: #{accepted_currencies.is_a?(String)}"
    if accepted_currencies.is_a?(String)
      logger.debug "Accepted currencies before processing: #{accepted_currencies}"
  
      self.accepted_currencies = accepted_currencies.gsub(/[{}"]/, '').split(',').map(&:strip)
  
      logger.debug "Accepted currencies after processing: #{accepted_currencies}"
    end
  end
end
