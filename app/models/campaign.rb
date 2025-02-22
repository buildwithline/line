# frozen_string_literal: true

class Campaign < ApplicationRecord
  # Associations
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet_id'
  belongs_to :repository

  # Validations
  validates :title, presence: { message: 'must be provided and cannot be blank.' }
  validates :accepted_currencies, length: { minimum: 1, message: 'must include at least one currency.' }, if: -> { accepted_currencies.present? }
  validates :repository_id, uniqueness: { message: 'A campaign for this repository already exists' }

  # Constants
  ALL_CURRENCIES = %w[USDC BTC ETH].freeze

  private

  def process_accepted_currencies
    currencies_param = params[:campaign][:accepted_currencies]

    return unless currencies_param.is_a?(String)

    processed_currencies = currencies_param.gsub(/[{}"]/, '').split(',').map(&:strip).reject(&:empty?)

    params[:campaign][:accepted_currencies] = processed_currencies
  end
end
