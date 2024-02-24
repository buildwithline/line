# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def handle_unverified_request
    render json: { error: 'CSRF token verification failed' }, status: :unprocessable_entity
  end
end
