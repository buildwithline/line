# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it 'is valid with valid attributes' do
    wallet = build(:wallet)
    expect(wallet).to be_valid
  end

  it 'is not valid without an address' do
    wallet = build(:wallet, address: nil)
    expect(wallet).not_to be_valid
  end

  it 'belongs to a user' do
    wallet = build(:wallet)
    expect(wallet.user).to be_present
  end
end
