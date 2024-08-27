# frozen_string_literal: true

module Users
  class CallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: %i[github]

    def github
      @user = User.from_omniauth(request.env['omniauth.auth'])

      # Pass the GitHub username to the GithubApiHelper
      # _github_api = GithubApiHelper.new(@user&.name)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
        SyncReposJob.perform_later(@user.id)
      else
        session['devise.github_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to root_path
      end
    end
  end
end
