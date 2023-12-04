import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="switch-button"
export default class extends Controller {
  static targets = ["info", "stats", "followers", "following", "albums", "artists", "songs", "all", "playlists"]
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

  switchToFollowers() {
    console.log("Switching to info");
    this.followersTarget.style.display = "block";
    this.followingTarget.style.display = "none";
  }

  switchToFollowing() {
    console.log("Switching to stats");
    this.followersTarget.style.display = "none";
    this.followingTarget.style.display = "block";
  }

  switchToAlbums() {
    console.log("Switching to Albums");
    this.albumsTarget.style.display = "block";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
  }

  switchToArtists() {
    console.log("Switching to Artist");
    this.albumsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
    this.artistsTarget.style.display = "block";
  }

  switchToSongs() {
    console.log("Switching to Songs");
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
    this.songsTarget.style.display = "block";
  }

  switchToPlaylists() {
    console.log("Switching to Playlists");
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    this.allTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "block"; // Display the playlists
    }
  }

  switchToAll() {
    console.log("Switching to All");
    this.albumsTarget.style.display = "none";
    this.artistsTarget.style.display = "none";
    this.songsTarget.style.display = "none";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "none";
    }
    this.allTarget.style.display = "block";
  }
  switchToAllOfIt() {
    console.log("Switching to All");
    this.albumsTarget.style.display = "block";
    this.artistsTarget.style.display = "block";
    this.songsTarget.style.display = "block";
    if (this.hasPlaylistsTarget){
      this.playlistsTarget.style.display = "block";
    }
    this.allTarget.style.display = "block";
  }
}
