# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Campaigns', type: :request do
  let(:user) { create(:user, uid: '12345', provider: 'github', github_access_token: 'mock_token', avatar_url: 'https://avatars.githubusercontent.com/u/12345?v=4' ) }
  let(:another_user) { create(:user, uid: '6789', provider: 'github', github_access_token: 'mock_token', avatar_url: 'https://avatars.githubusercontent.com/u/12345?v=4') }
  let(:repository) { create(:repository, user:) }
  let(:another_repository) { create(:repository, user: another_user) }
  let(:wallet) { create(:wallet, user:) }
  let(:another_repository_campaign) do
    create(:campaign, repository: another_repository, title: 'another repository campaign name', description: 'This is a great campaign')
  end

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
    sign_in user

    stub_request(:get, "https://api.github.com/repos/#{user.name}/#{repository.name}")
      .to_return(status: 200, body: {
        "id": 123,
        "name": 'example-repo',
        "full_name": "#{user.name}/example-repo",
        "owner": {
          "login": user.name,
          "avatar_url": "https://avatars.githubusercontent.com/u/#{user.id}?=4",
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
          post user_repository_campaigns_path(user_id: another_user.id, repository_id: another_repository.id),
               params: { campaign: valid_attributes }
        end.to_not change(Campaign, :count)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:alert]).to include('Repository not found or does not belong to you.')
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
    context 'when the user is not the creator of the campaign but is logged in' do
      it 'allows the user to see the campaign' do
        get user_repository_campaign_path(user_id: another_user.id, repository_id: another_repository.id, id: another_repository_campaign.id)
        expect(response).to be_successful
        expect(response.body).to include('another repository campaign name')
      end
    end

    context 'when the user is not logged in' do
      it 'still allows the user to see the campaign' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)

        get user_repository_campaign_path(user_id: another_user.id, repository_id: another_repository.id, id: another_repository_campaign.id)
        expect(response).to be_successful
        expect(response.body).to include('another repository campaign name')
      end
    end
  end
end