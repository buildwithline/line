# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  def new
  end

  def create
    user_info = request.env['omniauth.auth']
  end
end