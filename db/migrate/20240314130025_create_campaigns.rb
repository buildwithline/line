class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.references :user, null: false, foreign_key: true

      t.string :repo_identifier, null: true # Allow null for user-centric campaigns
      t.string :repo_url, null: true # Allow null
      t.references :receiving_wallet, null: false, foreign_key: { to_table: :wallets }
      t.string :title
      t.string :accepted_currency
      t.text :tiers
      t.decimal :amount, precision: 10, scale: 2
      t.string :contribution_cadence

      t.timestamps
    end
  end
end
