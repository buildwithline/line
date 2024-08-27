# frozen_string_literal: true

require 'rails_helper'
require 'timecop'

RSpec.describe SyncReposJob, type: :job do
  before do
    ActiveJob::Base.queue_adapter = :test
    Repository.delete_all
  end

  let(:user) { create(:user, uid: '12345', provider: 'github') }

  describe 'enqueue' do
    it 'enqueues the job' do
      expect do
        SyncReposJob.perform_later(user.id)
      end.to have_enqueued_job(SyncReposJob).with(user.id)
    end
  end

  describe 'perform' do
    before do
      @repo = create(:repository, user:, full_name: 'user/new_repo', created_on_github_at: 5.minutes.ago)
    end

    it 'creates a repository correctly' do
      expect(@repo).to be_persisted
      expect(@repo.full_name).to eq('user/new_repo')
    end

    it 'syncs new repositories' do
      Timecop.freeze(Time.current.beginning_of_day + 1.day) do
        allow(GithubApiHelper).to receive(:fetch_github_data).and_return(
          {
            repos: [
              {
                repo: {
                  full_name: 'user/newest_repo',
                  name: 'newest_repo',
                  html_url: 'http://github.com/user/newest_repo',
                  description: 'The newest repo',
                  private: false,
                  fork: false,
                  created_on_github_at: 5.minutes.ago,
                  updated_on_github_at: 5.minutes.ago,
                  pushed_to_github_at: 5.minutes.ago,
                  created_at: 5.minutes.ago,
                  updated_at: 5.minutes.ago
                }
              }
            ]
          }
        )
      end

      SyncReposJob.perform_now(user.id)

      user.reload
      expect(user.repositories.count).to eq(2)
      expect(user.repositories.last.full_name).to eq('user/newest_repo')
    end

    it 'correctly freezes time' do
      Timecop.freeze(Time.now) do
        expect(Time.now.hour).to eq(Time.now.hour)
      end
    end
  end
end
