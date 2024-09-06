# frozen_string_literal: true

class SyncReposJob < ApplicationJob
  sidekiq_options retry: 5
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    Rails.logger.debug "JOBS: Syncing repos for user: #{user.nickname}"
    SyncReposService.new(user).call
  end
end
