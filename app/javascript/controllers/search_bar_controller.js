import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-bar"
export default class extends Controller {
  static targets = [ "form", "mainContent" ]

  connect() {
    console.log("search bar connected");
    this.formTarget.addEventListener('keydown', (event) => {
      if (event.key === 'Enter') {
        this.search();
      }
    });
  }

  search(event) {
    if (event) event.preventDefault();

    const url = new URL(this.formTarget.action);
    const params = new URLSearchParams(new FormData(this.formTarget));
    url.search = params;

    fetch(url, {
      method: this.formTarget.method,
      headers: { 'Accept': 'application/json' }
    })
    .then(response => response.text())
    .then(data => {
      this.mainContentTarget.innerHTML = data;
    });
  }
}
