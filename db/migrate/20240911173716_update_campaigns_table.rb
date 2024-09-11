# frozen_string_literal: true

class UpdateCampaignsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :campaigns, :repo_identifier, :string
    change_column_null :campaigns, :title, false
    change_column_null :campaigns, :description, true
  end
end
