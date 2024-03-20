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
    this.selectedAmount = 25;
    this.selectedCurrency = 'USDC';
  }

  showCustomAmountModal() {
    this.toggleModalVisibility(true);
    this.selectedAmount = 'Custom';
    this.highlightSelectedAmountButton('Custom');
  }

  hideCustomAmountModal() {
    this.toggleModalVisibility(false);
  }

  toggleModalVisibility(isVisible) {
    this.customAmountModalTarget.classList.toggle('block', isVisible);
    this.customAmountModalTarget.classList.toggle('hidden', !isVisible);
  }

  confirmCustomAmount() {
    const customAmount = parseFloat(this.customAmountInputTarget.value);
    if (customAmount > 0) {
      this.hideCustomAmountModal();
    } else {
      console.error("Invalid custom amount. Please enter a number greater than 0.");
    }
  }

  cancelCustomAmount() {
    this.hideCustomAmountModal();
  }

  selectAmount(event) {
    const selectedAmount = event.currentTarget.dataset.campaignValue;
    this.selectedAmount = selectedAmount;
    this.highlightSelectedAmountButton(selectedAmount);
    this.updateCustomAmountVisibility(); 
  }


  highlightSelectedAmountButton(selectedAmount) {
    this.amountButtonTargets.forEach(button => {
      const isSelected = button.dataset.campaignValue === selectedAmount || (selectedAmount === 'Custom' && button.dataset.campaignValue === 'Custom');
      button.classList.toggle("bg-blue-500", isSelected);
      button.classList.toggle("text-white", isSelected);
      button.classList.toggle("bg-white", !isSelected);
      button.classList.toggle("text-black", !isSelected);
    });
  }

  updateCustomAmountVisibility() {
    if (this.selectedAmount === 'Custom') {
      this.showCustomAmountModal();
    } else {
      this.hideCustomAmountModal();
    }
  }

  selectCurrency(event) {
    const selectedCurrency = event.currentTarget.dataset.campaignValue;
    this.currencyButtonTargets.forEach(button => {
      const isSelected = button.dataset.campaignValue === selectedCurrency;
      button.classList.toggle("bg-blue-500", isSelected);
      button.classList.toggle("text-white", isSelected);
      button.classList.toggle("bg-white", !isSelected);
      button.classList.toggle("text-black", !isSelected);
    });
  }

  supportCampaign() {
    alert(`Thank you for your support of ${this.selectedAmount} ${this.selectedCurrency}!`);
    // Extend with actual logic for supporting the campaign
  }
}