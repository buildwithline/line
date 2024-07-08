import { Controller } from '@hotwired/stimulus';
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi';
import { mainnet, arbitrum } from 'viem/chains';
import { getAccount, reconnect } from '@wagmi/core';

export default class extends Controller {
  static targets = ['openModal'];
  static values = {
    projectId: String,
    userId: Number,
    walletIdValue: Number,
    csrfToken: String,
  };

  connect() {
    this.isDeleting = false;
    this.disconnectRequested = false;

    const projectId = this.projectIdValue;
    const chains = [mainnet, arbitrum];
    const metadata = {
      name: 'Web3Modal',
      description: 'Web3Modal Example',
      url: 'http://localhost:3000',
      icons: ['https://avatars.githubusercontent.com/u/37784886'],
    };

    this.config = defaultWagmiConfig({
      chains,
      projectId,
      metadata,
      enableWalletConnect: true,
      enableInjected: true,
      enableEIP6963: true,
      enableCoinbase: true,
    });
    reconnect(this.config);

    this.modal = createWeb3Modal({
      wagmiConfig: this.config,
      projectId: this.projectIdValue,
      enableAnalytics: true,
    });

    this.modal.subscribeEvents((event) => {
      this.account = getAccount(this.config);

      if (event.data.event === 'CONNECT_SUCCESS') {
        this.addWalletToDatabase(this.account);
        this.openModalTarget.textContent = 'Disconnect Wallet';
      } else if (
        event.data.event === 'MODAL_CLOSE' &&
        this.disconnectRequested &&
        !event.data.properties.connected
      ) {
        this.removeWalletFromDatabase(this.account);
        this.openModalTarget.textContent = 'Connect Wallet';
      } else {
        console.log('Modal closed without disconnection');
      }
    });
  }

  openModal() {
    const isDisconnect =
      this.openModalTarget.textContent === 'Disconnect Wallet';
    this.disconnectRequested = isDisconnect;
    this.modal.open();
  }

  async addWalletToDatabase(account) {
    const walletData = {
      wallet: {
        address: account.address,
      },
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
        throw new Error(`Network response was not ok: ${response.statusText}`);
      }

      const responseData = await response.json();
      console.log('Successfully created wallet in database:', responseData);
    } catch (error) {
      console.error('Error creating wallet in database:', error);
    }
  }

  async removeWalletFromDatabase() {
    if (this.isDeleting) {
      console.log('Already deleting wallet, aborting.');
      return;
    }
    this.isDeleting = true;

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
      console.log('Successfully removed from database:', responseData);
      this.openModalTarget.textContent = 'Connect Wallet';
    } catch (error) {
      console.error('Error removing wallet from database:', error);
    } finally {
      this.isDeleting = false;
      this.disconnectRequested = false;
    }
  }
}
