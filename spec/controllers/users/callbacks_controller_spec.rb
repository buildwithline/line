# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::CallbacksController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    allow(User).to receive(:from_omniauth).and_return(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #github' do
    context 'when user from omniauth is not persisted' do
      let(:user) { build(:user) }

      it 'redirects to the home page' do
        get :github

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user from omniauth is persisted' do
      let(:user) { create(:user) }

      it 'signs in the user and redirects to the home page' do
        get :github

        expect(response).to redirect_to(root_path)
        expect(controller.current_user).to eq(user)
      end
    end
  end
end
