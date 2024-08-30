# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Users::CallbacksController, type: :controller do
  include Devise::Test::ControllerHelpers
  Sidekiq::Testing.fake!

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123456',
      info: {
        email: 'test@example.com',
        nickname: 'testuser'
      },
      credentials: {
        token: 'mock_token'
      }
    )

    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

    stub_request(:get, 'https://api.github.com/user')
      .with(
        headers: {
          'Authorization' => 'token mock_token',
          'User-Agent' => 'RailsApp',
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
        }
      )
      .to_return(
        status: 200,
        body: {
          login: 'testuser',
          avatar_url: 'http://example.com/avatar.png',
          html_url: 'http://example.com/testuser'
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe 'GET #github' do
    context 'when user does not exist' do
      it 'creates a user and redirects to the home page' do
        expect do
          get :github
        end.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(controller.current_user).to eq(User.last)
      end
    end

    context 'when user already exists' do
      let!(:user) { create(:user, uid: '123456', provider: 'github', email: 'test@example.com') }

      it 'signs in the user and redirects to the home page' do
        expect do
          get :github
        end.not_to change(User, :count)

        expect(response).to redirect_to(root_path)
        expect(controller.current_user).to eq(user)
      end

      it 'enqueues a SyncReposJob' do
        expect do
          get :github
        end.to have_enqueued_job(SyncReposJob).with(user.id)
      end
    end
  end
end
