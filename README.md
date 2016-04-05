# xander

First and foremost: This is all pretty rough. I didn't expect someone to look at this code.
So if (or rather when) you see something odd, confusing or wrong, please feel free to
make it better or change it.

`ruby-app` is probably what you're interested in.

* `bot.rb` - slack client (web and rtm) and xander are instantiated here.
* `xander.rb` - decides which "action" from `actions` is taken, if any.

If not included the VCR cassets and dictionaries for the markov chains, since they contain some team specific
data I'm not comfortable sharing atm. Ping me if you need help with that.


As far as deployment goes, I'm hosting this on a VPS of mine atm. You can have a look
at the `Dockerfile` to see whats included. (In case you want timing/cron related libs).

I'm pretty tired now, but you can send me dm and I'll probably respond tomorrow.

Cheers,
Philipp
