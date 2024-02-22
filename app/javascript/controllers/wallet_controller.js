import { Controller } from "@hotwired/stimulus"
import { createWeb3Modal, defaultConfig } from "@web3modal/ethers"

export default class extends Controller {
  static targets = [ "openModal" ]

  connect(){
    // 1. Get projectId at https://cloud.walletconnect.com
     const projectId = process.env.PROJECT_ID

    // 2. Set chains
    const mainnet = {
      chainId: 1,
      name: "Ethereum",
      currency: "ETH",
      explorerUrl: "https://etherscan.io",
      rpcUrl: "https://cloudflare-eth.com"
    }

    // 3. Create modal
    const metadata = {
      name: "My Website",
      description: "My Website description",
      url: "https://mywebsite.com", // origin must match your domain & subdomain
      icons: ["https://avatars.mywebsite.com/"]
    }

    this.modal = createWeb3Modal({
      ethersConfig: defaultConfig({ metadata }),
      chains: [mainnet],
      projectId,
      enableAnalytics: true // Optional - defaults to your Cloud configuration
    })
  }
 
  openConnectModal(){
    this.modal.open()
  }

  closeConnectModal() {
    this.modal.close();
  }
}