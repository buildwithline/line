# frozen_string_literal: true

class AddGitHubAccessTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_access_token, :string
  end
end
