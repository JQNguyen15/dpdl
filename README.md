# DPDL

Welcome to DPDL. This app is still in alpha stages and is a WIP.
This app is made to track stats of inhouse games in DotA 2.
DPDL uses the Microsoft TrueSkill algorithm implementation.
Feel free to contribute. Live demo is at https://dpdl.herokuapp.com.

## TODO

* ~~Leaderboard - Show top ranked gamers on the DPDL leaderboard.~~
* Forbid feature - Gamers on DPDL should be able to forbid other
users from their games.
* Admin features - Admins should be able to resolve issues such as
resulting a game or aborting a game.
* ~~Refactor/cleanup code for future devs on DPDL.~~
* ~~Stat tracking - Users should be able to see win/loss statistics~~
* ~~Recent Games - Implement a recent games list~~
* Show players how much they won or loss after each match.
* Notification/Sounds for when game is full/starts.
* Rework UI.
* Captains Mode - Allow 2 players to challenge each other and pick
teams based on a player pool.
* ~~Rework rails action cable to use 1 connection per user.~~
* Test Suite - Implement unit, integration and acceptance testing.

## Requirements

Currently, development on DPDL is supported on OSX. In order to
contribute to DPDL, you will need the following software:

* Rails 5.0+
* Ruby 2.3.0+
* Postgres

## Getting Started

To run this app on your local machine, clone the repo then run

```
bundle install
```

To create the database
```
rails db:create
```

Next, migrate the database
```
rails db:migrate
```

To start a server
```
rails s
```

Now you can visit localhost:3000.

To deploy on heroku simply connect the project on github with your
heroku app. Next run

```
heroku run rake db:migrate --app <yourapp>
```

Note: To get ActionCable working on heroku, make sure that all
the dpdl.herokuapp.com is replaced with your app name.

## Standards and Conventions

DPDL tries to follow the https://github.com/styleguide/ruby when
possible.
