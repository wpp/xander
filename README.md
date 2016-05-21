# xander

[![CircleCI](https://circleci.com/gh/wpp/xander/tree/master.svg?style=svg)](https://circleci.com/gh/wpp/xander/tree/master)

`ruby-app` contains the main logic of the application.

* `bot.rb` - slack client (web and rtm) and xander are instantiated here.
* `xander.rb` - decides which "response" from `responses` is taken, if any.

If not included the dictionaries for the markov chains, since they contain some team specific
data I'm not comfortable sharing atm.

As far as deployment goes, I'm hosting this on a VPS of mine atm. You can have a look
at the `Dockerfile` to see whats included. (In case you want timing/cron related libs).

## Resources

- [Bungie API docs](http://destinyapi.wiki/)
- [Slack API docs](https://api.slack.com/rtm)
- [CircleCI](https://circleci.com/docs/gettingstarted/)
