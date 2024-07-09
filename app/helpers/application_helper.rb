# frozen_string_literal: true

module ApplicationHelper
  def wallet_connected?
    current_user.wallet.present?
  end
end
