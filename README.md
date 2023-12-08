# Beatween

This is a project developed by five students at Le Wagon. It aims to socialize personal music taste more, so the user can see their friends trends, create a joint playlist on spotify and more.

## Demo

Please give it a try!
[Beatween](https://beatween-e1ae66294d65.herokuapp.com/)
*As a development project, you need to be whitelisted to access the webpage funcionality due to certain API

## Screenshots

TODO: Added Screenshots

## Technologies Used
  ![Rails](https://img.shields.io/badge/Rails-CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
  ![Ruby](https://img.shields.io/badge/Ruby-v3.1.0-green.svg)
  ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E.svg?style=for-the-badge&logo=javascript&logoColor=black)
  ![SCSS](https://img.shields.io/badge/SCSS-CC6699.svg?style=for-the-badge&logo=sass&logoColor=white)
  ![Turbo](https://img.shields.io/badge/Turbo-CC4B37.svg?style=for-the-badge&logo=turbo&logoColor=white)
  ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
  ![Heroku](https://img.shields.io/badge/Heroku-430098.svg?style=for-the-badge&logo=heroku&logoColor=white)
  ![GitHub](https://img.shields.io/badge/GitHub-100000.svg?style=for-the-badge&logo=github&logoColor=white)

## Features

- Be up to date with followed users musical taste.
- Match, comapre stats and create playlists with your friends or even another artist
- See relevant information about songs, albums and artists.
- Discover new music and navigate through the app up until the last moment.
- At the moment, this app is designed to have just mobile in mind, thus the design is not as reactive. Desktop users will have to wait a bit for the moment.

## Installation

To run this project on a development enviroment, please keep in mind the following:
- A CLIENT_ID and CLIENT_SECRET from spotify are required. This should go to an ENV file or similar methods.
- Run all the proper migrations and db creation. The project uses [pgSQL](https://guides.rubyonrails.org/active_record_postgresql.html)
- The chatrooms use Active Cable, and do need to have Redis on your machine, to do this please follow this steps:
```
 # On macOS
  brew update
  brew install redis
  brew services start redis

  # On Ubuntu
  sudo apt-get install redis-server
```

## Usage

Show examples of usage, how to use your project, images, and code examples.

## API Reference

This project was based on the [Spotify API](https://developer.spotify.com/documentation/web-api) tools. Authorizations and part of the requests were handled by [RSpotify](https://github.com/guilhermesad/rspotify) gem.

## Contributors
  - [Andrea Zambrano](https://github.com/azambrano16)
  - [Elia Benedetti](https://github.com/thefrenchmessiah)
  - [Federico Palou](https://github.com/fpalou)
  - [Gustavo Franco](https://github.com/GusFrancoH)
  - [Tiphaine Ollivier](https://github.com/Tiphaineoz)



## Contributing

Contributions are always welcome! We dont know what the future for this project is, but please reach out so you can be whitelisted.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Federico Palou de comasema - [LinkedIn Profile](https://www.linkedin.com/in/federicopalou/) - yourEmail@example.com
