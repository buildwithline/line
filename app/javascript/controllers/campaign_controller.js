import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "amountButton",
    "currencyButton",
    "walletAddress",
    "supportButton",
    "customAmountModal",
    "customAmountInput"
  ]

  connect() {
    this.selectedAmount = 25; // Default amount
    this.selectedCurrency = 'USDC'; // Default currency
    this.hideCustomAmountModal() 
  }

  showCustomAmountModal() {
    this.customAmountModalTarget.classList.add('block');
  }

  hideCustomAmountModal() {
    this.customAmountModalTarget.classList.remove('block');
  }

  confirmCustomAmount() {
    // Get the custom amount from the input field
    const customAmount = parseFloat(this.customAmountInputTarget.value);
    if (customAmount > 0) {
      // Close the modal
      this.hideCustomAmountModal();

      // Update the UI with the custom amount
      // this.updateContributionDisplay(customAmount);
    } else {
      // Show an error message or handle invalid input
      console.log("Invalid custom amount. Please enter a number greater than 0.");
    }
  }

  cancelCustomAmount() {
    // Close the modal without updating the UI
    this.hideCustomAmountModal();
  }

  selectAmount(event) {
    const selectedAmount = event.currentTarget.dataset.campaignValue;
    this.amountButtonTargets.forEach((button) => {
        if (button.dataset.campaignValue === selectedAmount) {
            button.classList.add("bg-blue-500", "text-white");
            button.classList.remove("bg-white", "text-black");
        } else {
            button.classList.remove("bg-blue-500", "text-white");
            button.classList.add("bg-white", "text-black");
        }
    });
  }

  selectCurrency(event) {
    const selectedCurrency = event.currentTarget.dataset.campaignValue;
    this.currencyTargets.forEach((button) => {
        if (button.dataset.campaignValue === selectedCurrency) {
            button.classList.add("bg-blue-500", "text-white");
            button.classList.remove("bg-white", "text-black");
        } else {
            button.classList.remove("bg-blue-500", "text-white");
            button.classList.add("bg-white", "text-black");
        }
    });
  }

  supportCampaign() {
    // This method simulates a support action
    alert(`Thank you for your support of ${this.selectedAmount} ${this.selectedCurrency}!`);
    // Here you can add actual logic to handle the campaign support action, such as making an API call
  }
}