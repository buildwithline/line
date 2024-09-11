# frozen_string_literal: true

require 'rails_helper'
require 'timecop'

RSpec.describe SyncReposJob, type: :job do
  before do
    ActiveJob::Base.queue_adapter = :test
    Repository.delete_all
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
      @repository = create(:repository, user:, full_name: 'user/new_repository', created_on_github_at: 5.minutes.ago)
    end

    it 'creates a repository correctly' do
      expect(@repository).to be_persisted
      expect(@repository.full_name).to eq('user/new_repository')
    end

    it 'syncs new repositories' do
      Timecop.freeze(Time.current.beginning_of_day + 1.day) do
        allow_any_instance_of(SyncReposService).to receive(:call).and_return(
          [
            {
              id: 123,
              full_name: 'user/newest_repository',
              name: 'newest_repository',
              html_url: 'http://github.com/user/newest_repository',
              description: 'The newest repository',
              private: false,
              fork: false,
              created_on_github_at: 5.minutes.ago,
              updated_on_github_at: 5.minutes.ago,
              pushed_to_github_at: 5.minutes.ago,
              created_at: 5.minutes.ago,
              updated_at: 5.minutes.ago
            }
          ]
        )
      end

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
