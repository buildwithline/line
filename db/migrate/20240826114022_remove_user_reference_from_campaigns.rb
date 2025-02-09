# frozen_string_literal: true

class RemoveUserReferenceFromCampaigns < ActiveRecord::Migration[7.1]
  def up
    remove_foreign_key :campaigns, :users if foreign_key_exists?(:campaigns, :users)
    remove_column :campaigns, :user_id
  end

  def down
    add_column :campaigns, :user_id, :integer, null: false
    add_foreign_key :campaigns, :users, column: :user_id
  end
end
