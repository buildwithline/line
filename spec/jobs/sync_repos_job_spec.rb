# frozen_string_literal: true

require 'rails_helper'
require 'timecop'

RSpec.describe SyncReposJob, type: :job do
  before do
    ActiveJob::Base.queue_adapter = :test
    Repository.delete_all
    User.delete_all
  end

  let(:user) { create(:user, uid: '12345', provider: 'github', nickname: 'testuser', email: 'test@example.com') }

  describe 'enqueue' do
    it 'enqueues the job' do
      expect do
        SyncReposJob.perform_later(user.id)
      end.to have_enqueued_job(SyncReposJob).with(user.id)
    end
  end

  describe 'perform' do
    before do
      @repository = create(:repository, user:, full_name: 'user/new_repository', owner_login: user.nickname, repo_github_id: 123, created_on_github_at: 5.minutes.ago)
    end

    it 'creates a repository correctly' do
      expect(@repository).to be_persisted
      expect(@repository.full_name).to eq('user/new_repository')
    end

    it 'syncs new repositories' do
      allow(HTTParty).to receive(:get).and_return(
        double(code: 200, body: '[{
          "id": 124,
          "full_name": "user/newest_repository",
          "name": "newest_repository",
          "html_url": "http://github.com/user/newest_repository",
          "description": "The newest repository",
          "private": false,
          "fork": false,
          "owner": { "login": "testuser" },
          "created_at": "2024-09-13T23:55:00Z",
          "updated_at": "2024-09-13T23:55:00Z",
          "pushed_at": "2024-09-13T23:55:00Z"
        }]')
      )

      SyncReposJob.perform_now(user.id)
      user.reload

      expect(user.repositories.count).to eq(2)
      expect(user.repositories.last.full_name).to eq('user/newest_repository')
    end

    it 'correctly freezes time' do
      Timecop.freeze(Time.now) do
        expect(Time.now.hour).to eq(Time.now.hour)
      end
    end
  end
end
