import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-button"
export default class extends Controller {
  static targets = ["info", "stats", "albums", "artists", "songs", "all"]
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

  switchToAlbums() {
    console.log("Switching to Albums");
    this.albumsTarget.style.display = "block";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
  }

  switchToArtists() {
    console.log("Switching to Artist");
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "block";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
  }

  switchToSongs() {
    console.log("Switching to Songs");
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "block";
    this.allTarget.style.display = "none";
  }

  switchToAll() {
    console.log("Switching to All");
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "block";
  }
}
