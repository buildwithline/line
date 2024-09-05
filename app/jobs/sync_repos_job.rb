# frozen_string_literal: true

class SyncReposJob < ApplicationJob
  sidekiq_options retry: 5
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    service = SyncReposService.new(user)

    service.call
  end
end
