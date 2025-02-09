# frozen_string_literal: true

module Users
  class CallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: %i[github]

    def github
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        Rails.logger.debug "User persisted: #{@user.inspect}"
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
      else
        Rails.logger.debug "User could not be persisted: #{@user.errors.full_messages.join(', ')}"
        # session['devise.github_data'] = request.env['omniauth.auth'].except('extra')
        flash[:alert] = 'Failed to sign in with GitHub. Please try again later.'
        redirect_to new_user_session_path
      end
    end
  end
end
