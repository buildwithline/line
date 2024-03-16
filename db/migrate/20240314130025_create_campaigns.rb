class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.references :user, null: false, foreign_key: true

      # We store `repo_identifier` to associate campaigns with specific repositories without maintaining a separate repos table.
      # Since repository data is fetched dynamically from the GitHub API based on this identifier,
      # it allows us to keep our database schema simplified while still linking campaigns to their respective GitHub repositories.
      # This approach is chosen to reduce redundancy and reliance on storing external data that might change frequently.
      t.string :repo_identifier, null: true # Allow null for user-centric campaigns
      t.references :receiving_wallet, null: false, foreign_key: { to_table: :wallets }
      t.string :title
      t.text :description
      t.string :accepted_currency
      t.string :tier_name
      t.decimal :tier_amount, precision: 10, scale: 2
      t.string :contribution_cadence

      t.timestamps
    end
  end
end
