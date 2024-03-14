class Campaign < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet'

  # We store `repo_identifier` to associate campaigns with specific repositories without maintaining a separate repos table.
  # Since repository data is fetched dynamically from the GitHub API based on this identifier,
  # it allows us to keep our database schema simplified while still linking campaigns to their respective GitHub repositories.
  # This approach is chosen to reduce redundancy and reliance on storing external data that might change frequently.
  column :repo_identifier, :string

  # Validation for title, ensure it's present or meets your criteria
  validates :title, presence: true
  validates :repo_identifier, presence: true
  validates :repo_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  # Optional association indicator for UI logic or elsewhere
  def repo_centric?
    repo_identifier.present?
  end
end
