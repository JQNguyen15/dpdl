# DPDL

Welcome to DPDL. This app is still in alpha stages and is a WIP.
This app is made to track stats of inhouse games in DotA 2.
DPDL uses the Microsoft TrueSkill algorithm implementation.
Feel free to contribute. Live demo is at https://dpdl.herokuapp.com.

## TODO

#### Priority: High

* Fix TrueSkill algorithm to match http://boson.research.microsoft.com/trueskill/rankcalculator.aspx

#### Priority: Medium
* ~~Leaderboard - Show top ranked gamers on the DPDL leaderboard.~~
* Forbid feature - Gamers on DPDL should be able to forbid other
users from their games.
* Admin features - Admins should be able to resolve issues such as
resulting a game or aborting a game.
* Refactor/cleanup code for future devs on DPDL.
* ~~Stat tracking - Users should be able to see win/loss statistics~~
* Compare players - Users should be able to compare their stats with another player
* Recent Games - Implement a recent games list with stats on which
team won and how much each player won.
* Notification/Sounds for when game is full/starts.
* Rework UI.
* Captains Mode - Allow 2 players to challenge each other and pick
teams based on a player pool.
* Rework rails action cable to use 1 connection per user.

#### Priority: Low
* Test Suite - Implement unit, integration and acceptance testing.
* Chatroom - Gamers on DPDL should have a readily and easy to use
chatroom.
* Individual PMs - Allow people to privately message each other

## Requirements

Currently, development on DPDL is supported on OSX. In order to
contribute to DPDL, you will need the following software:

* Rails 5.0+
* Ruby 2.3.0+

## Getting Started

To run this app on your local machine, clone the repo then run

```
bundle install
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

## Workflow

DPDL uses the
[GitHub Flow](https://guides.github.com/introduction/flow/). The
`master` branch must always be in a production-ready state. If you
want to work on a feature or a fix, just branch off the latest master,
commit your work on that branch, and make a pull request. Your work
will be reviewed and discussed in that pull request. Once all
automated checks have cleared, and the pull request has been
peer-reviewed, it is merged back into master.

### Branch Names

Branch names should be descriptive of the feature or fix that they
contain.

### Commit Messages

Commit messages should be short but descriptive. Use the first line as
a summary, and the body of the commit for more detailed
explanations. Try to keep the first line below 50 characters, and wrap
the body at 72 characters wide.

Use the present tense in the first line of the commit. For instance,
favour "Add frobnicator" over "Added frobnicator".

For more details on our commit message guidelines and the rationale,
refer to
[How to Write a Git Commit Message](http://chris.beams.io/posts/git-commit/)
by Chris Beams.
