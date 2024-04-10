import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "currencyButton",
    "selectAll"
  ]

  connect() {
    console.log('connect currency selection controller')
    this.selectedCurrency = 'USDC';
  }

  selectCurrency(event) {
    event.preventDefault()
    const selectedCurrency = event.currentTarget.dataset.contributionValue;
    console.log(selectedCurrency)
    this.currencyButtonTargets.forEach(button => {
      const isSelected = button.dataset.contributionValue === selectedCurrency;
      button.classList.toggle("bg-blue-500", isSelected);
      button.classList.toggle("text-white", isSelected);
      button.classList.toggle("bg-white", !isSelected);
      button.classList.toggle("text-black", !isSelected);
    });
  }

  selectAll() {
    const isSelected = !this.selectAllTarget.classList.contains('bg-blue-500');
    this.buttonTargets.forEach(button => {
      if (isSelected) {
        button.classList.add('bg-blue-500', 'text-white');
      } else {
        button.classList.remove('bg-blue-500', 'text-white');
      }
    });
    this.selectAllTarget.classList.toggle('bg-blue-500');
    this.selectAllTarget.classList.toggle('text-white');
  }
}