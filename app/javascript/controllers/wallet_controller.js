import { Controller } from "@hotwired/stimulus"
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi'
import { mainnet, arbitrum } from 'viem/chains'
import { getAccount, reconnect } from '@wagmi/core'

import { ethers } from 'ethers'

export default class extends Controller {
  static targets = [ "openModal" ]
  static values = {
    projectId: String,
    userId: Number
  }

  connect() {
    console.log('connect method')
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

    console.log('config', this.config)
    
    this.modal = createWeb3Modal({
      wagmiConfig: this.config,
      projectId: this.projectIdValue,
      enableAnalytics: true
    });
    console.log('create modal')
    this.modal.subscribeEvents(event => {
      console.log("new state", event.data)
      const account = getAccount(this.config)
      console.log('account in modal', account)
      // conditional if address there then send to backend
    })
  }

  openConnectModal() {
    this.modal.open();
  }

  // Function to send the account address to the backend
  // async sendAccountToBackend(account) {
  //   console.log('account that was sent along in sendtobaackend', account)

  //   const account = getAccount(this.config)
  //   console.log('account in sendtobaackend', account)
  //   try {
  //     const response = await fetch('/users/:user_id/wallets', {
  //       method: 'POST',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // Include any other headers your backend requires
  //       },
  //       body: JSON.stringify({ wallet_address: account }),
  //     });

  //     if (!response.ok) {
  //       throw new Error('Network response was not ok');
  //     }

  //     const responseData = await response.json();
  //     console.log('Successfully sent account to backend:', responseData);
  //     // Additional actions based on the response (e.g., update UI)
  //   } catch (error) {
  //     console.error('Error sending account to backend:', error);
  //   }
  // }
}