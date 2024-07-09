# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Campaign Creation', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    WebMock.disable_net_connect!(allow_localhost: true, allow: ['chromedriver.storage.googleapis.com'])
    allow_any_instance_of(ApplicationHelper).to receive(:wallet_connected?).and_return(false)
  end

  let(:user) { create(:user) }

  context 'when wallet is not connected' do
    before do
      sign_in user
      visit root_path
    end

    it 'shows the disabled button with tooltip' do
      expect(page).to have_button('Create Campaign', disabled: true)
      expect(page).to have_css('.tooltip-text', text: 'Please connect a wallet to create campaigns')
    end
  end

  context 'when wallet is connected' do
    before do
      allow_any_instance_of(ApplicationHelper).to receive(:wallet_connected?).and_return(true)
      sign_in user
      visit root_path
    end

    it 'shows the enabled button without tooltip and navigates to new campaign page' do
      expect(page).to have_button('Create Campaign', disabled: false)
      expect(page).not_to have_css('.tooltip-text')

      click_button 'Create Campaign'
      expect(page).to have_current_path(new_user_campaign_path(user))
    end
  end
end
