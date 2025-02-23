import { Controller } from "@hotwired/stimulus";
import {
  requestWalletConnection,
  sendContributionTransaction,
} from "../web3/transfer";

export default class extends Controller {
  static targets = [
    "amountButton",
    "currencyButton",
    "walletAddress",
    "contributeButton",
    "customAmountModal",
    "customAmountInput",
  ];

  connect() {
    this.selectedAmount = 25;
    this.selectedCurrency = "USDC";
  }

  async contribute() {
    const amountValue =
      this.selectedAmount === "Custom"
        ? parseFloat(this.customAmountInputTarget.value)
        : this.selectedAmount;

    if (isNaN(amountValue) || amountValue <= 0) {
      alert("Invalid amount. Please enter a number greater than 0.");
      return;
    }

    try {
      const walletClient = await requestWalletConnection();
      const accounts = await walletClient.getAddresses();

      if (accounts.length === 0) {
        alert("Wallet cinnection failes. Please connect your wallet");
        return;
      }

      const senderAddress = accounts[0];
      const recipientAddress = this.walletAddressTarget.value;

      const confirmation = confirm(
        `You are about to send ${amountValue} ${this.selectedCurrency} to ${recipientAddress}. Do you want to proceed? `
      );
      if (!confirmation) return;

      const tx = await sendContributionTransaction(
        senderAddress,
        recipientAddress,
        amountValue,
        walletClient
      );

      alert(`Transaction successful. Transaction hash: ${tx.hash}`);
    } catch (error) {
      console.error("Error sending transaction:", error);
      alert("Transaction failed. Please try again.");
    }
  }

  showCustomAmountModal() {
    this.toggleModalVisibility(true);
    this.selectedAmount = "Custom";
    this.highlightSelectedAmountButton("Custom");
  }

  hideCustomAmountModal() {
    this.toggleModalVisibility(false);
  }

  toggleModalVisibility(isVisible) {
    this.customAmountModalTarget.classList.toggle("block", isVisible);
    this.customAmountModalTarget.classList.toggle("hidden", !isVisible);
  }

  confirmCustomAmount() {
    const customAmount = parseFloat(this.customAmountInputTarget.value);
    if (customAmount > 0) {
      this.hideCustomAmountModal();
    } else {
      alert("Invalid custom amount. Please enter a number greater than 0.");
    }
  }

  cancelCustomAmount() {
    this.hideCustomAmountModal();
  }

  selectAmount(event) {
    const selectedAmount = event.currentTarget.dataset.contributionValue;
    this.selectedAmount = selectedAmount;
    this.highlightSelectedAmountButton(selectedAmount);
    this.updateCustomAmountVisibility();
  }

  highlightSelectedAmountButton(selectedAmount) {
    this.amountButtonTargets.forEach((button) => {
      const isSelected =
        button.dataset.contributionValue === selectedAmount ||
        (selectedAmount === "Custom" &&
          button.dataset.contributionValue === "Custom");
      button.classList.toggle("bg-blue-500", isSelected);
      button.classList.toggle("text-white", isSelected);
      button.classList.toggle("bg-white", !isSelected);
      button.classList.toggle("text-black", !isSelected);
    });
  }

  updateCustomAmountVisibility() {
    if (this.selectedAmount === "Custom") {
      this.showCustomAmountModal();
    } else {
      this.hideCustomAmountModal();
    }
  }

  selectCurrency(event) {
    const selectedCurrency = event.currentTarget.dataset.contributionValue;
    this.currencyButtonTargets.forEach((button) => {
      const isSelected = button.dataset.contributionValue === selectedCurrency;
      button.classList.toggle("bg-blue-500", isSelected);
      button.classList.toggle("text-white", isSelected);
      button.classList.toggle("bg-white", !isSelected);
      button.classList.toggle("text-black", !isSelected);
    });
  }
}
