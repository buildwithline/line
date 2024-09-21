# frozen_string_literal: true

class Contribution < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :campaign
  belongs_to :sending_wallet, class_name: 'Wallet', foreign_key: 'sending_wallet'
end
