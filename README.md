# Playedby.me
Playedby.me manages your playlist in realtime. Unlike collaborative playlists like Spotify, Playedby.me allows guests to vote on and add songs they want to share from their mobile app. By taking votes into consideration, we ensure that your guests are satisfied and the music evolves with the mood of your party. 

We’ve made it super simple for hosts to create playlists by integrating with Facebook. You can create a playlist from a Facebook Event and have all your guests notified with 1-click or you can create a playlist from scratch in seconds. 

Playedby.me is like taking the best elements of Spotify, Soundcloud, and iTunes and making them work better for parties. Playedby.me facilitates music discovery, enriches social experiences, and willl transform the way people make decisions about music at parties. 

Setup
-------------
See the [environment setup wiki](https://github.com/HKApps/ocarina/wiki/Environment-setup).

Test Instructions
-------------
### Frontend Specs
Visit `/jasmine` in the browser

### Backend Specs
In the console, create and migrate the test database:

```bash
$ bundle exec rake db:test:prepare
```

Next, run the test server:

```bash
$ bundle exec spork
```

This will initialize the rails app once rather than before each test run. If you change configuration settings or any spec factories, restart spork.

Now run the test suite:

```bash
$ bundle exec rspec --drb
```

