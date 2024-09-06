# frozen_string_literal: true

class SyncReposService
  def initialize(user)
    @user = user
  end

  def call
    response = HTTParty.get("https://api.github.com/users/#{@user.nickname}/repos",
                            headers: { 'Accept': 'application/vnd.github+json' })
    Rails.logger.debug "GitHub API Response: #{response.code} - #{response.body}"
    response.each do |repo_data|
      repo = Repository.find_or_create_by(repo_github_id: repo_data['id']) do |r|
        r.user = @user
        r.name = repo_data['name']
        r.full_name = repo_data['full_name']
        r.owner_login = repo_data['owner']['login']
        r.html_url = repo_data['html_url']
        r.description = repo_data['description']
        r.private = repo_data['private']
        r.fork = repo_data['fork']
        r.created_on_github_at = repo_data['created_at']
        r.updated_on_github_at = repo_data['updated_at']
        r.pushed_to_github_at = repo_data['pushed_at']
      end

      Rails.logger.debug "Repository synced: #{repo.full_name}"

      next unless repo.persisted? && repo.changed?

      repo.update(
        name: repo_data['name'],
        full_name: repo_data['full_name'],
        owner_login: repo_data['owner']['login'],
        html_url: repo_data['html_url'],
        description: repo_data['description'],
        private: repo_data['private'],
        fork: repo_data['fork'],
        created_on_github_at: repo_data['created_at'],
        updated_on_github_at: repo_data['updated_at'],
        pushed_to_github_at: repo_data['pushed_at']
      )
      Rails.logger.debug "Repository updated and synced: #{repo.full_name}"
    end
    # daraus ertsellen wir unsere repos with data
    # if already exist in db, then update, if not then create in db
    # if in dbs that are not included in repsonse, then removen ?! still keep and display?, if set private fpr example, do soft de;lete and keep in db?
    # LATER authentication, user needs scopes to repos, wenn token benutzt werden
    # 1) fetch alle repos, die schon on db sind
    #  save in db
    #  error handling
    #  include button to enquee job
  end
end
