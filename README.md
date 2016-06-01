# xander

[![CircleCI](https://circleci.com/gh/wpp/xander/tree/master.svg?style=svg)](https://circleci.com/gh/wpp/xander/tree/master)

`ruby-app` contains the main logic of the application.

* `bot.rb` - slack client (web and rtm) and xander are instantiated here.
* `xander.rb` - decides which "response" from `responses` is taken, if any.

If not included the dictionaries for the markov chains, since they contain some team specific
data I'm not comfortable sharing atm.

As far as deployment goes, I'm hosting this on a VPS of mine atm. You can have a look
at the `Dockerfile` to see whats included. (In case you want timing/cron related libs).

## Getting Started

1. Install Ruby
2. Install Bundler with `gem install bundler`
3. `cd ruby-app` to swap to the main directory
4. `bundle install` in the root directory of the project to get the dependencies
5. `touch .testbot` to create a blank API token file (you don't need a token unless you are running new tests)
6. `rake` to run the tests!

## Resources

- [Bungie API docs](http://destinyapi.wiki/)
- [Slack API docs](https://api.slack.com/rtm)
- [CircleCI](https://circleci.com/docs/gettingstarted/)
