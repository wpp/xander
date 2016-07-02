+# Xander

[![CircleCI](https://circleci.com/gh/wpp/xander/tree/master.svg?style=svg)](https://circleci.com/gh/wpp/xander/tree/master)

## Getting Started

1. Install Ruby
2. Install Bundler with `gem install bundler`
3. `cd ruby-app` to swap to the main directory
4. `bundle install` in the root directory of the project to get the dependencies
5. `touch .testbot` to create a blank API token file (you don't need a token unless you are running new tests)
6. `rake` to run the tests!

## Structure of the project

### `ruby-app/`

Contains the main logic of Xander.

#### `bot.rb`

Initiates one instance of `Xander`, the `Slack::RealTime::Client` (web and rtm)
and establishes the connection to the team. (Via `SLACK_API_TOKEN` environmental variable)

#### `xander.rb`

In `get_response_for` we decide which `Response` Xander returns for a certain message.
Currently we rely on Regexe's to do that job. If you want to test some of them out
you can do so at [rubular.com](http://rubular.com).

#### `responses/`

The directory containing all of the possible Xander responses.

If you want to add a new response, drop it in here.
Your `Response` should inherit from `Base` and implement the `text` and `attachments` methods.
Those 2 are called when replying via `client.web_client.chat_postMessage` in bot.rb.

### `config/`

Contains deployment/docker-related configuration files.


## Adding a new response

So in summary, if you want to add a new response:

1. Create a new test `test/responses/my_new_response_test.rb`
2. Create a new response `lib/responses/`
3. Add regex and case to `xander.rb`
4. Run tests `rake test`
5. Commit
6. Push


## Other notes

I've not included the dictionaries for the markov chains, since they contain some team specific
data I'm not comfortable sharing atm.

As far as deployment goes, I'm hosting this on a VPS of mine atm. You can have a look
at the `Dockerfile` to see what's included. (In case you want timing/cron related libs).


## Resources

- [Bungie API docs](http://destinyapi.wiki/)
- [Slack API docs](https://api.slack.com/rtm)
- [CircleCI](https://circleci.com/docs/gettingstarted/)
- [How to Read the Manifest (Reference)](https://www.bungie.net/en/Clan/Post/39966/105901734/0/0)
