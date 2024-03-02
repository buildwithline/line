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
    console.log('connect method new')
    const projectId = this.projectIdValue;
    const chains = [mainnet, arbitrum];
    console.log('id', projectId)
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
    
    // Then, when creating the modal...
    this.modal = createWeb3Modal({
      wagmiConfig: this.config,
      projectId: this.projectIdValue,
      enableAnalytics: true
    });
    // Create modal and configure event listeners for wallet connection
    console.log('create modal')
    console.log(this.modal)
    
  

    // Listen for the event indicating the wallet has connected
    // const account = useAccount()

    // console.log(account)
    // this.modal.on('connect', (provider) => {
    //   console.log('on connect')
    //   // Now that the wallet is connected, get the address
    //   const address = this.modal.getAddress(); // Using getAddress as you intended
    //   console.log("Connected address:", address);

    //   // Perform any additional actions with the address, such as sending it to your backend
    //   this.sendAddressToBackend(address);
    // });
  }

  // openConnectModal() {
  //   try {
  //     const modalResult = await this.modal.open();
  //     console.log('Modal result:', modalResult); // Debugging: Check what the modal returns upon opening

  //     // Assuming modalResult.provider should have the provider, adjust as per actual API response
  //     if (!this.modal.provider) {
  //         console.error('Provider is undefined. Make sure the connection is established correctly.');
  //         return;
  //     }

  //     const provider = new ethers.providers.Web3Provider(this.modal.provider);
  //     const signer = provider.getSigner();
  //     const address = await signer.getAddress();
  //     const network = await provider.getNetwork();
      
  //     console.log('in try', network, address, provider, signer);
      
  //     this.sendWalletDetailsToServer(address, network.chainId);
  // } catch (error) {
  //     console.error('Error connecting to the wallet:', error);
  // }

  // async openConnectModal() {
  //   try {
  //     await this.modal.open();
  //     console.log("modal opened")
  //     // Assuming you have a way to access the connected provider from the modal
  //     const provider = new ethers.providers.Web3Provider(window.ethereum);
  //     const signer = provider.getSigner();
  //     const address = await signer.getAddress();
  //     console.log("Connected address:", address);
  //     // Perform actions with the address, like sending it to your backend
  //   } catch (error) {
  //     console.error('Error connecting to the wallet:', error);
  //   }
  // }

  // this gets me the address of the wallet when clikcing the openModal button a second time
  openConnectModal() {
    console.log('modal open')
    this.modal.open();
    const account = getAccount(this.config)
    console.log('account', account)
  }

//   // latest adjustments that will not give me the address even after clicking the openModal button a second time
//   
// async openConnectModal() {
//     console.log('Opening modal...meow');
//     try {
//         // Open the modal and wait for the user to connect their wallet
//         const modalResult = await this.modal.open();
//         console.log(this.modal.open)
//         console.log('User completed interaction:', modalResult);

//         // Check if the modalResult includes a provider directly
//         // This step depends on how your modal and library are set up
//         // You might need to adjust this based on the actual structure of modalResult
//         if (modalResult && modalResult.provider) {
//             console.log('Provider available, fetching account details...');

//             const provider = new ethers.providers.Web3Provider(modalResult.provider);
//             const signer = provider.getSigner();
//             const accountAddress = await signer.getAddress();

//             console.log('Connected account:', accountAddress);
//         } else {
//             console.error('Connection completed, but no provider available.');
//         }
//     } catch (error) {
//         console.error('Error during wallet connection:', error);
//     }
// }
}