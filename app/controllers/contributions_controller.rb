# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_receiving_wallet, only: %i[new create]

  def new
    pp 'new action'
    @campaign = Campaign.find(params[:campaign_id])
    pp '++++++++++++++++++++'
    
    pp @campaign
    pp '++++++++++++++++++++'
    @receiving_wallet = @campaign.receiving_wallet.address
    @sending_wallet = current_user.wallet.address

    @contribution = Contribution.new
    @accepted_currencies = @campaign.accepted_currencies.split(',')
    # we need receiving wallet and sending wallet
    # receiving is connected to campaign, owner of campaign has a wallet in db
    # sending wallet is the current_user. what happens is this is your campaign? any different display?
    #  if this is your campaign, you should not be able to send funds, because that would be redundant and only cost gas
    #  if this is not your campaign, you should be able to send funds
    # if this is your campaign, instead of contibute button could display a share this campaign button 
    #  that would copy the url to the clipboard

#  <p id="wallet-address"><%= @sending_wallet.address if @user.wallet.present? %></p>
#         <% unless @user.wallet.present? %>
#           <%= button_tag "Add Wallet", type: "button", class: "text-blue-600 hover:text-blue-800", data: { action: "wallet#openConnectModal" } %>
#         <% end %>
#       </div>
#     <% end %> 
    end

  def create
    pp 'create contrib'
    @receiving_wallet = @campaign.receiving_wallet_id
    @sending_wallet = current_user.wallet_id

    p @receiving_wallet
    p @sending_wallet

  end

  private

  def contributions_params
    params.require(:contribution).permit(:contribution_cadence, :repo_identifier, :receiving_wallet_id, accepted_currencies: [])
  end
end
