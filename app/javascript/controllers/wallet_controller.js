import { Controller } from "@hotwired/stimulus"
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi'
import { mainnet, arbitrum } from 'viem/chains'

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

    this.wagmiConfig = defaultWagmiConfig({
      chains, // required
      projectId, // required
      metadata, // required
      enableWalletConnect: true,
      enableInjected: true,
      enableEIP6963: true,
      enableCoinbase: true,
    });
    
    // Then, when creating the modal...
    this.modal = createWeb3Modal({
      wagmiConfig: this.wagmiConfig,
      projectId: this.projectIdValue,
      enableAnalytics: true
    });
    // Create modal and configure event listeners for wallet connection
    console.log('create modal')


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

  openConnectModal() {
    this.modal.open();
  }
//   connect(){
//     console.log('connect')
//     // 1. Get projectId at https://cloud.walletconnect.com
//     const projectId = this.projectIdValue

//     // 2. Set chains
//     const mainnet = {
//       chainId: 1,
//       name: 'Ethereum',
//       currency: 'ETH',
//       explorerUrl: 'https://etherscan.io',
//       rpcUrl: 'https://cloudflare-eth.com'
//     }

//     // 3. Create modal
//     const metadata = {
//       name: 'My Website',
//       description: 'My Website description',
//       url: 'https://mywebsite.com', // origin must match your domain & subdomain
//       icons: ['https://avatars.mywebsite.com/']
//     }

//     this.modal = createWeb3Modal({
//       ethersConfig: defaultConfig({ metadata }),
//       chains: [mainnet],
//       projectId,
//       enableAnalytics: true // Optional - defaults to your Cloud configuration
//     })

//     console.log(this.modal.getAddress())
//   }

//   openConnectModal() {
//     try {
//       const modalResult = await this.modal.open();
//       console.log('Modal result:', modalResult); // Debugging: Check what the modal returns upon opening

//       // Assuming modalResult.provider should have the provider, adjust as per actual API response
//       if (!this.modal.provider) {
//           console.error('Provider is undefined. Make sure the connection is established correctly.');
//           return;
//       }

//       const provider = new ethers.providers.Web3Provider(this.modal.provider);
//       const signer = provider.getSigner();
//       const address = await signer.getAddress();
//       const network = await provider.getNetwork();
      
//       console.log('in try', network, address, provider, signer);
      
//       this.sendWalletDetailsToServer(address, network.chainId);
//   } catch (error) {
//       console.error('Error connecting to the wallet:', error);
//   }
// }

  // closeConnectModal() {
  //   this.modal.close();
  // }
}