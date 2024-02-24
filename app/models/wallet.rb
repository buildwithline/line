class Wallet < ApplicationRecord
  belongs_to :user

  validates :address, presence: true, uniqueness: true # f.e. address format?
end
