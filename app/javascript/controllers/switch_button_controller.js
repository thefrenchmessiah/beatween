import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-button"
export default class extends Controller {
  connect() {
    console.log("Switch Button Controller connected!");
  }

  switchToInfo() {
    console.log("Switching to info");
  }
  switchToStats() {
    console.log("Switching to Stats");
  }
}
