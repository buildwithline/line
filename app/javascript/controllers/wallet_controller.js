import { Controller } from "@hotwired/stimulus"
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi'
import { mainnet, arbitrum } from 'viem/chains'
import { getAccount, reconnect } from '@wagmi/core'

export default class extends Controller {
  static targets = [ "openModal" ]
  static values = {
    projectId: String,
    userId: Number,
    walletIdValue: Number,
    csrfToken: String
  }

  connect() {
    this.isDeleting = false
    
    const projectId = this.projectIdValue;
    const chains = [mainnet, arbitrum];
    const metadata = {
      name: 'Web3Modal',
      description: 'Web3Modal Example',
      url: 'https://web3modal.com', // origin must match your domain & subdomain
      icons: ['https://avatars.githubusercontent.com/u/37784886']
    }

    this.config = defaultWagmiConfig({
      chains, // required
      projectId, // required
      metadata, // required
      enableWalletConnect: true,
      enableInjected: true,
      enableEIP6963: true,
      enableCoinbase: true,
    });
    reconnect(this.config)

    this.modal = createWeb3Modal({
      wagmiConfig: this.config,
      projectId: this.projectIdValue,
      enableAnalytics: true
    });

    this.modal.subscribeEvents(event => {
      this.account = getAccount(this.config)

      if(event.data.event == 'CONNECT_SUCCESS') {
        console.log('connected', event.data.event)
        this.sendAccountToBackend(this.account)
        this.openModalTarget.textContent = 'Disconnect Wallet'
      } else if(event.data.event == 'MODAL_CLOSE') {
        console.log('not connected')
        this.removeWalletFromDatabase(this.account)
        this.openModalTarget.textContent = 'Connect Wallet'
      }
    })
  }

  openConnectModal() {
    this.modal.open();
  }

  async removeWalletFromDatabase() {
    // Guard clause to prevent multiple simultaneous deletions
    if (this.isDeleting) return;
    this.isDeleting = true;
  
    console.log('Attempting to disconnect wallet for user', this.userIdValue);
    try {
      const response = await fetch(`/users/${this.userIdValue}/wallet`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfTokenValue,
        },
      });
  
      if (!response.ok) {
        throw new Error(`Network response was not ok: ${response.statusText}`);
      }
  
      const responseData = await response.json();
      console.log('Successfully removed from DB:', responseData);
      this.openModalTarget.textContent = 'Connect Wallet';
    } catch (error) {
      console.error('Error removing wallet from backend:', error);
    } finally {
      this.isDeleting = false; // Reset the flag
    }
  }
  

  async sendAccountToBackend(account) {
    const walletData = {
      wallet: {
        address: account.address,
        // chain_id: account.chain.id,
      }
    };

    try {
      const response = await fetch(`/users/${this.userIdValue}/wallet`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfTokenValue,
        },
        body: JSON.stringify(walletData),
      });
  
      if (!response.ok) {
        // If the response is not okay, throw an error with the status text
        throw new Error(`Network response was not ok: ${response.statusText}`);
      }
  
      const responseData = await response.json();
      console.log('Successfully sent account to backend:', responseData);
      // Additional actions based on the response (e.g., update UI)
    } catch (error) {
      console.error('Error sending account to backend:', error);
    }
  }
}