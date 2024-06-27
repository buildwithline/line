# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
    allow(GithubApiHelper).to receive(:fetch_github_data).and_return({
                                                                       user_info: { login: 'testuser' },
                                                                       organizations: [],
                                                                       repos: []
                                                                     })
  end

  describe 'GET #index' do
    it 'fetches GitHub data and renders the index template' do
      get :index
      expect(assigns(:github_user_data)).not_to be_nil
      expect(response).to render_template(:index)
    end

    it 'handles GitHub data fetch failure' do
      allow(GithubApiHelper).to receive(:fetch_github_data).and_return(nil)
      get :index
      expect(flash[:alert]).to eq('Failed to retrieve GitHub data. Please try again later.')
      expect(response).to redirect_to(root_path)
    end
  end
end
