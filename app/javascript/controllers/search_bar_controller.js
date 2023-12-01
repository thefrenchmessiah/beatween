import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-bar"
export default class extends Controller {
  static targets = [ "form", "mainContent" ]

  connect() {
    console.log("search bar connected");
  }

  search(event) {
    event.preventDefault();

    fetch(this.formTarget.action, {
      method: this.formTarget.method,
      body: new FormData(this.formTarget),
      headers: { 'Accept': 'application/json' }
    })
    .then(response => response.text())
    .then(data => {
      this.mainContentTarget.outerHTML = data;

    });
}
