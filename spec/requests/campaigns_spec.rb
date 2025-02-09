require 'rails_helper'

RSpec.describe 'Campaigns', type: :request do
  let(:user) { create(:user, uid: '12345', provider: 'github', github_access_token: 'mock_token') }
  let(:another_user) { create(:user, uid: '6789', provider: 'github', github_access_token: 'mock_token') }
  let(:repository) { create(:repository, user:) }
  let(:another_repository) { create(:repository, user: another_user) }
  let(:another_repository_campaign) { create(:campaign, repository: another_repository, title: 'another repository campaign name', description: 'This is a great campaign') }
  let(:wallet) { create(:wallet, user:) }
  # let(:another_wallet) { create(:wallet, user: another_user) }
  let(:valid_attributes) do
    {
      receiving_wallet_id: wallet.id,
      title: 'My Campaign Title',
      description: 'My Campaign Description',
      accepted_currencies: %w[USD EUR],
      repository_id: repository.id
    }
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    stub_request(:get, "https://api.github.com/repos/#{user.name}/#{repository.name}")
      .to_return(status: 200, body: {
        "id": 123,
        "name": 'example-repo',
        "full_name": "#{user.name}/example-repo",
        "owner": {
          "login": user.name,
          "id": user.id
        }
      }.to_json, headers: {})

    stub_request(:get, "https://api.github.com/repos/#{another_user.name}/#{another_repository.name}")
      .to_return(status: 200, body: {
        "id": 456,
        "name": 'example-another-repo',
        "full_name": "#{another_user.name}/example-another-repo",
        "owner": {
          "login": another_user.name,
          "id": another_user.id
        }
      }.to_json, headers: {})
  end

  describe 'POST /create' do
    context 'when the user owns the repository' do
      it 'creates a new campaign with valid attributes' do
        expect do
          post user_repository_campaigns_path(user_id: user.id, repository_id: repository.id), params: { campaign: valid_attributes }
        end.to change(Campaign, :count).by(1)
      end
    end

    context 'when the user does not own the repository' do
      it 'cannot create a new campaign' do
        expect do
          post user_repository_campaigns_path(user_id: another_user.id, repository_id: another_repository.id), params: { campaign: valid_attributes }
        end.to_not change(Campaign, :count)
      end
    end
  end

  describe 'GET /new' do
    it 'returns a success response' do
      get new_user_repository_campaign_path(user_id: user.id, repository_id: repository.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    context 'when the user is not creator of campaign and is logged-in' do
      it 'allows user to see campaign' do
        get user_repository_campaign_path(user_id: another_user.id, repository_id: another_repository.id, id: another_repository_campaign.id)
        expect(response).to be_successful
        expect(response.body).to include('another repository campaign name')
      end
    end

    context 'when the user is not creator of campaign and is not logged-in' do
      it 'allows user to see campaign' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)

        get user_repository_campaign_path(user_id: another_user.id, repository_id: another_repository.id, id: another_repository_campaign.id)
        expect(response).to be_successful
        expect(response.body).to include('another repository campaign name')
      end
    end
  end
end
