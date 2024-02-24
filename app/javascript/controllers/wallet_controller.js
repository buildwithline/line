import { Controller } from "@hotwired/stimulus"
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import WalletConnectProvider from "@walletconnect/web3-provider";

export default class extends Controller {
  static values = {
    projectId: String,
    userId: Number 
  }

  async connect() {
    this.initializeWeb3Modal();
  }

  async initializeWeb3Modal() {
    const providerOptions = {
      walletconnect: {
        package: WalletConnectProvider,
        options: {
          infuraId: this.projectIdValue
        }
      }
    };

    const web3Modal = new Web3Modal({
      network: "mainnet", // Optional. If you want to connect to a specific network by default
      cacheProvider: true, // Optional. If you wish to cache the provider chosen by the user
      providerOptions // Required
    });

    try {
      const connection = await web3Modal.connect();
      const provider = new ethers.providers.Web3Provider(connection);
      this.handleProvider(provider);
    } catch (error) {
      console.error("Could not get a wallet connection", error);
    }
  }

  async handleProvider(provider) {
    const signer = provider.getSigner();
    const address = await signer.getAddress();
    const network = await provider.getNetwork();

    this.sendWalletInfoToBackend(address, network.chainId);
  }

  sendWalletInfoToBackend(address, chainId) {
    const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
    const userId = this.userIdValue;

    const data = {
      wallet: {
        address: address,
        chain_id: parseInt(chainId, 16), // Convert hex chainId to integer
        user_id: userId
      }
    };
  
    fetch(`/users/${userId}/wallets`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify(data)
    })
    .then(response => {
      if (response.ok) {
        console.log('Wallet info saved successfully');
      } else {
        console.error('Failed to save wallet info');
      }
    })
    .catch(error => console.error('Error:', error));
  }

  openConnectModal() {
    this.modal.open();
  }

  closeConnectModal() {
    this.modal.close();
  }
}
