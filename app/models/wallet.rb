# frozen_string_literal: true

class Wallet < ApplicationRecord
  # Associations
  belongs_to :user, dependent: :destroy
  has_many :sent_contributions, class_name: 'Contribution', foreign_key: 'sending_wallet'
  has_many :receiving_campaigns, class_name: 'Campaign', foreign_key: 'receiving_wallet'

  # Validations
  validates :address, presence: true, uniqueness: true # f.e. address format?
  # validates :chain_id, presence: true needed?
end
