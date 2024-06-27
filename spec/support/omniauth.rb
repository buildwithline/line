# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  provider: 'github',
                                                                  uid: '123456',
                                                                  info: {
                                                                    email: 'test@example.com'
                                                                  },
                                                                  credentials: {
                                                                    token: 'mock_token'
                                                                  }
                                                                })
  end

  config.after(:each) do
    OmniAuth.config.mock_auth[:github] = nil
  end
end
