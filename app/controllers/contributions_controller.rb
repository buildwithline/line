# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create; end

  private

  def contributions_params
    params.require(:campaign).permit(:tier_amount, :tier_name, :contribution_cadence, :accepted_currency, :repo_identifier, :receiving_wallet_id)
  end
end
