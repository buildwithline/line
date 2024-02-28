# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user

  validates :address, presence: true, uniqueness: true # f.e. address format?
  # validates :chain_id, presence: true needed?
end
