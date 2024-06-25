# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.integer :chain_id
      t.string :nickname

      t.timestamps
    end
  end
end
