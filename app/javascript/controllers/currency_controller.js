import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "currencyButton",
    "selectAll",
    "acceptedCurrencies",
    "form",
  ];

  connect() {
    this.selectedCurrencies = this.currencyButtonTargets
      .filter((button) => button.classList.contains("bg-blue-500"))
      .map((button) => button.dataset.currencyValue);

    this.updateAcceptedCurrenciesField();
    this.updateSelectAllState();
  }

  selectCurrency(event) {
    event.preventDefault();
    const currency = event.currentTarget.dataset.currencyValue;
    const button = event.currentTarget;

    button.classList.toggle("bg-blue-500");
    button.classList.toggle("text-white");
    button.classList.toggle("bg-white");
    button.classList.toggle("text-black");

    const isSelected = button.classList.contains("bg-blue-500");

    if (isSelected) {
      if (!this.selectedCurrencies.includes(currency)) {
        this.selectedCurrencies.push(currency);
      }
    } else {
      const index = this.selectedCurrencies.indexOf(currency);
      if (index !== -1) {
        this.selectedCurrencies.splice(index, 1);
      }
    }

    this.updateAcceptedCurrenciesField();
    this.updateSelectAllState();
  }

  selectAll(event) {
    const isChecked = this.selectAllTarget.checked;
    const label = document.getElementById("select-all-label");
    label.textContent = isChecked ? "Unselect All" : "Select All";

    this.currencyButtonTargets.forEach((button) => {
      button.classList.toggle("bg-blue-500", isChecked);
      button.classList.toggle("text-white", isChecked);
      button.classList.toggle("bg-white", !isChecked);
      button.classList.toggle("text-black", !isChecked);
      const currency = button.dataset.currencyValue;
      if (isChecked && !this.selectedCurrencies.includes(currency)) {
        this.selectedCurrencies.push(currency);
      } else if (!isChecked) {
        this.selectedCurrencies = this.selectedCurrencies.filter(
          (c) => c !== currency
        );
      }
    });
    this.updateAcceptedCurrenciesField();
  }

  updateAcceptedCurrenciesField() {
    this.acceptedCurrenciesTarget.value = this.selectedCurrencies.join(",");
    console.log(this.selectedCurrencies);
  }

  updateSelectAllState() {
    const allSelected = this.currencyButtonTargets.every((button) =>
      button.classList.contains("bg-blue-500")
    );

    this.selectAllTarget.checked = allSelected;

    const label = document.getElementById("select-all-label");
    label.textContent = allSelected ? "Unselect All" : "Select All";
  }

  handleSubmit(event) {
    event.preventDefault();

    this.updateAcceptedCurrenciesField();

    this.formTarget.submit();
  }
}
