import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-button"
export default class extends Controller {
  static targets = ["info", "stats"]
  connect() {
    console.log("Switch Button Controller connected!");
  }
  switchToInfo() {
    console.log("Switching to info");
    this.infoTarget.style.display = "block";
    this.statsTarget.style.display = "none";
  }

  switchToStats() {
    console.log("Switching to stats");
    this.infoTarget.style.display = "none";
    this.statsTarget.style.display = "block";
  }
}
