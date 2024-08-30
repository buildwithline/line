# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }
  let(:github_service) { instance_double(GithubApiService) }

  before do
    sign_in user
    allow(GithubApiService).to receive(:new).and_return(github_service)
    allow(github_service)
      .to receive(:fetch_user_data)
      .and_return({
                    'login' => 'testuser',
                    'avatar_url' => 'http://example.com/avatar.png',
                    'html_url' => 'http://example.com/testuser'
                  })
  end

  describe 'GET #index' do
    it 'fetches GitHub data and renders the index template' do
      get :index, format: :html
      expect(assigns(:github_user_data)).not_to be_nil
      expect(response).to render_template(:index)
    end

    it 'handles GitHub data fetch failure' do
      allow(github_service).to receive(:fetch_user_data).and_return(nil)
      get :index, format: :html
      expect(flash[:alert]).to eq('Failed to retrieve GitHub data. Please try again later.')
      expect(response).to redirect_to(root_path)
    end
  end
end
