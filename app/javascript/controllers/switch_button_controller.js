import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-button"
export default class extends Controller {
  static targets = ["info", "stats", "albums", "artists", "songs", "all", "playlists"]
  connect() {
    // console.log("Switch Button Controller connected!");
  }

  switchToInfo(event) {
    // console.log("Switching to info");
    this.removeActiveClassLong();
    let button = event.currentTarget.querySelector('.btn-flat-long');
    button.classList.add('button-active');
    this.infoTarget.style.display = "block";
    this.statsTarget.style.display = "none";
  }

  switchToStats(event) {
    // console.log("Switching to stats");
    this.removeActiveClassLong();
    let button = event.currentTarget.querySelector('.btn-flat-long');
    button.classList.add('button-active');
    this.infoTarget.style.display = "none";
    this.statsTarget.style.display = "block";
  }


  switchToAlbums(event) {
    // console.log("Switching to Albums");
    this.removeActiveClassShort();
    event.currentTarget.classList.add('button-active');
    this.albumsTarget.style.display = "block";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
  }

  switchToArtists(event) {
    // console.log("Switching to Artist");
    this.removeActiveClassShort();
    event.currentTarget.classList.add('button-active');
    this.albumsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
    this.artistsTarget.style.display = "block";
  }

  switchToSongs(event) {
    // console.log("Switching to Songs");
    this.removeActiveClassShort();
    event.currentTarget.classList.add('button-active');
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
    this.songsTarget.style.display = "block";
  }

  switchToPlaylists(event) {
    // console.log("Switching to Playlists");
    this.removeActiveClassShort();
    event.currentTarget.classList.add('button-active');
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "block"; // Display the playlists
    }
  }

  switchToAll(event) {
    // console.log("Switching to All");
    this.removeActiveClassShort();
    event.currentTarget.classList.add('button-active');
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
    this.allTarget.style.display = "block";
  }
  switchToAllOfIt(event) {
    // console.log("Switching to All");
    this.removeActiveClassShort();
    event.currentTarget.classList.add('button-active');
    this.albumsTarget.style.display = "block";
    this.artistsTarget.style.display = "block";
    this.songsTarget.style.display = "block";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "block";
    }
    this.allTarget.style.display = "block";
  }
  removeActiveClassLong() {
    const buttons = document.querySelectorAll('.btn-flat-long');
    buttons.forEach(button => button.classList.remove('button-active'));
  }
  removeActiveClassShort() {
    const buttons = document.querySelectorAll('.show-filter button');
    buttons.forEach(button => button.classList.remove('button-active'));
  }
}
