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
  }

  showCustomAmountModal() {
    this.toggleModalVisibility(true);
    this.selectedAmount = 'Custom'; // Assuming this is how you track the selected amount
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
      // Logic to handle valid custom amount
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
      console.log('what is selected?')
      console.log('selectedAmount === "Custom"', selectedAmount === "Custom")
      console.log("button.dataset.campaignValue === 'Custom'", button.dataset.campaignValue === 'Custom')
      console.log('isselected', isSelected)
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
  // updateCustomAmountVisibility() {
  //   if (this.selectedAmount === 'Custom') {
  //     this.showCustomAmountModal();
  //   } else {
  //     this.hideCustomAmountModal();

  //   }
  // }

  // confirmCustomAmount() {
  //   // Get the custom amount from the input field
  //   const customAmount = parseFloat(this.customAmountInputTarget.value);
  //   if (customAmount > 0) {
  //     this.hideCustomAmountModal();
  //     // Update the UI with the custom amount
  //     // this.updateContributionDisplay(customAmount);
  //   } else {
  //     // Show an error message or handle invalid input
  //     console.log("Invalid custom amount. Please enter a number greater than 0.");
  //   }
  // }

  // cancelCustomAmount() {
  //   this.hideCustomAmountModal();
  //   this.customAmountModalTarget.classList.add('hidden');
  // }

  // selectAmount(event) {
  //   const selectedAmount = event.currentTarget.dataset.campaignValue;
  //   this.selectedAmount = selectedAmount;
  //   this.amountButtonTargets.forEach((button) => {
  //       if (button.dataset.campaignValue === selectedAmount) {
  //           button.classList.add("bg-blue-500", "text-white");
  //           button.classList.remove("bg-white", "text-black");
  //       } else {
  //           button.classList.remove("bg-blue-500", "text-white");
  //           button.classList.add("bg-white", "text-black");
  //       }
  //   });
  //   this.updateCustomAmountVisibility(); 
  // }

  // selectCurrency(event) {
  //   const selectedCurrency = event.currentTarget.dataset.campaignValue;
  //   this.currencyTargets.forEach((button) => {
  //       if (button.dataset.campaignValue === selectedCurrency) {
  //           button.classList.add("bg-blue-500", "text-white");
  //           button.classList.remove("bg-white", "text-black");
  //       } else {
  //           button.classList.remove("bg-blue-500", "text-white");
  //           button.classList.add("bg-white", "text-black");
  //       }
  //   });
  // }

  // supportCampaign() {
  //   // This method simulates a support action
  //   alert(`Thank you for your support of ${this.selectedAmount} ${this.selectedCurrency}!`);
  //   // Here you can add actual logic to handle the campaign support action, such as making an API call
  // }
}