class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.references :sending_wallet, null: false, foreign_key: { to_table: :wallets }
      t.string :contribution_cadence
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency

      t.timestamps
    end
  end
end
