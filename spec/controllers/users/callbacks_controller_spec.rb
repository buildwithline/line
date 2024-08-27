# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Users::CallbacksController, type: :controller do
  include Devise::Test::ControllerHelpers
  Sidekiq::Testing.fake!

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
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
