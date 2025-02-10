# frozen_string_literal: true

class SyncReposService
  def initialize(user)
    @user = user
  end

  def call
    Rails.logger.debug "Syncing repos for user with nickname: #{@user.nickname}"
    response = HTTParty.get("https://api.github.com/users/#{@user.nickname}/repos",
                            headers: { 'Accept': 'application/vnd.github+json' })
    if response.code == 200
      repositories_data = JSON.parse(response.body)
      Rails.logger.debug "GitHub API Response: #{response.code} - #{response.body}"

      repositories_data.each do |repository_data|
        repository = Repository.find_or_initialize_by(repo_github_id: repository_data['id']).tap do |r|
          r.user = @user
          r.name = repository_data['name']
          r.full_name = repository_data['full_name']
          r.owner_login = repository_data['owner']['login']
          r.html_url = repository_data['html_url']
          r.description = repository_data['description']
          r.private = repository_data['private']
          r.fork = repository_data['fork']
          r.created_on_github_at = repository_data['created_at']
          r.updated_on_github_at = repository_data['updated_at']
          r.pushed_to_github_at = repository_data['pushed_at']
        end

        repository.save!
      end
    else
      Rails.logger.error "GitHub API Request failed: #{response.code} - #{response.message}"
    end
  end
end
