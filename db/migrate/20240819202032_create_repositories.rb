# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[7.1]
  def change
    create_table :repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name
      t.string :name
      t.string :owner_login
      t.string :html_url
      t.text :description
      t.boolean :private
      t.boolean :fork
      t.datetime :created_on_github_at
      t.datetime :updated_on_github_at
      t.datetime :pushed_to_github_at

      t.timestamps
    end
    add_index :repositories, :full_name
  end
end
