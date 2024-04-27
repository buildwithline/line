class ChangeAcceptedCurrencyToArray < ActiveRecord::Migration[6.0]
  def up
    rename_column :campaigns, :accepted_currency, :accepted_currencies
    change_column :campaigns, :accepted_currencies, :text, array: true, default: [], using: 'accepted_currencies::text[]'
  end

  def down
    change_column :campaigns, :accepted_currencies, :string, default: nil, using: "array_to_string(accepted_currencies, ',')"
  end
end
