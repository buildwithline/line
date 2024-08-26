# frozen_string_literal: true

class AddRepoIdToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_reference :campaigns, :repository, null: false, foreign_key: true
  end
end
