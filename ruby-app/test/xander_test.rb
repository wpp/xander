require_relative 'test_helper'
require_relative '../lib/xander'

class XanderTest < Minitest::Test
  def setup
    @client = Slack::RealTime::Client.new
    selfm = mock()
    selfm.expects(:id).returns('botid').at_least_once
    @client.expects(:self).returns(selfm).at_least_once
    @xander = Xander.new(@client)
    @user   = 'U0TUWEY6R'
    @bot    = '<@botid>'
  end

  def test_ignores_normal_messages
    [
      'could be fun in void burn nightfalls',
      "Cool. What's 13 strange coins anyway. :)",
      'last week was heart of praxic fire, it’s a good time for warlocks'
    ].each { |message| refute @xander.respond_to(message, @user) }
  end

  def test_responds_to_direct_messages
    [
      'could be fun in void burn nightfalls',
      "Cool. What's 13 strange coins anyway. :)",
      'last week was heart of praxic fire, it’s a good time for warlocks'
    ].each { |message| assert @xander.respond_to(message, @user, 'D') }
  end

  def test_my_elo_default
    [
      "#{@bot} my elo",
      "#{@bot} MY ELO",
      "My elo #{@bot}"
    ].each do |my_elo|
      VCR.use_cassette('trials_map') do
        response = @xander.respond_to(my_elo, @user)
        assert_equal "Hi <@#{@user}> your trials elo is: *1214*.", response.text
      end
    end
  end

  def test_my_elo_olly
    VCR.use_cassette('elo_olly') do
      response = @xander.respond_to("#{@bot} my elo", @user)
      assert_equal "Hi <@U0TUWEY6R> your trials elo is: *1180* (PSN) *couldn’t find one* (XBOX).", response.text
    end
  end

  def test_my_elo_gamemode
    [
      { msg: "#{@bot} my control elo",     mode: 'control',     elo: 1267  },
      { msg: "#{@bot} My skirmish elo",    mode: 'skirmish',    elo: 1119  },
      { msg: "#{@bot} MY SALVAGE ELO",     mode: 'salvage',     elo: 1204  },
      { msg: "#{@bot} my RIFT elo",        mode: 'rift',        elo: 1128  },
      { msg: "#{@bot} my elimination elo", mode: 'elimination', elo: 1142  },
      { msg: "#{@bot} my iron banner elo", mode: 'iron banner', elo: 1235  }
    ].each do |expected|
      VCR.use_cassette('elo') do
        response = @xander.respond_to(expected[:msg], @user)
        assert_equal "Hi <@#{@user}> your #{expected[:mode]} elo is: *#{expected[:elo]}*.", response.text
      end
    end
  end

  def test_my_elo_unkown_gamemode_defaults_to_trials
    VCR.use_cassette('elo_fo_wpp31') do
      response = @xander.respond_to("#{@bot} my unkowngamemode elo", @user)
      assert_equal "Hi <@#{@user}> your trials elo is: *1214*.", response.text
    end
  end

  def test_elo_gamertag_unkown_gamemode
    VCR.use_cassette('elo_fo_samsymons') do
      response = @xander.respond_to("#{@bot} unkowngamemode elo for samsymons", @user)
      assert_equal "Hi <@#{@user}> samsymons's elo for trials is: *1534*.", response.text
    end
  end

  def test_elo_gamertag
    VCR.use_cassette('elo_fo_wpp31') do
      response = @xander.respond_to("#{@bot} elo for wpp31", @user)
      assert_equal "Hi <@#{@user}> wpp31's elo for trials is: *1214*.", response.text
    end

    VCR.use_cassette('elo_fo_samsymons') do
      response = @xander.respond_to("#{@bot} elo for samsymons", @user)
      assert_equal "Hi <@#{@user}> samsymons's elo for trials is: *1534*.", response.text
    end
  end

  def test_elo_at_slack_user
    VCR.use_cassette('elo_for_@rorith') do
      response = @xander.respond_to("#{@bot} elo for <@U0PCXGYJX>", @user)
      assert_equal "Hi <@#{@user}> Rorith__'s elo for trials is: *1369*.", response.text
    end
  end

  def test_elo_ranking
    skip
  end

  def test_elo_rankings_gamemode
    skip
  end

  def test_elo_ranking_with_missing_slack_title
    skip
  end

  def test_elo_ranking_when_on_of_them_has_wrong_slack_title
    skip
  end

  def test_elo_ranking_iron_banner
    skip
  end

  def test_elo_ranking_at_slack_user_and_gamertag_mixed
    skip
  end

  def test_elo_at_slack_user_no_gamertag
    VCR.use_cassette('elo_for_@rorith_no_gamertag') do
      response = @xander.respond_to("#{@bot} elo for <@U0PCXGYJX>", @user)
      assert_equal "Hi <@U0TUWEY6R> I can't get a gamertag for rorith. Her/His title on slack is `aaa`. They need to visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: gamertag` or `XB1: gamertag`)", response.text
    end
  end

  def test_elo_gamertag_and_gametype
    VCR.use_cassette('elo_fo_samsymons') do
      response = @xander.respond_to("rumble elo for samsymons #{@bot}", @user)
      assert_equal "Hi <@#{@user}> samsymons's elo for rumble is: *1313*.", response.text
    end

    VCR.use_cassette('elo_fo_kurzinator') do
      response = @xander.respond_to("rift elo for kurzinator #{@bot}", @user)
      assert_equal "Hi <@#{@user}> kurzinator's elo for rift is: *1142*.", response.text
    end

    VCR.use_cassette('elo_fo_kurzinator') do
      response = @xander.respond_to("iron banner elo for kurzinator #{@bot}", @user)
      assert_equal "Hi <@#{@user}> kurzinator's elo for iron banner is: *1180*.", response.text
    end
  end

  def test_elo_gamertag_not_found
    VCR.use_cassette('gamertag_not_found') do
      response = @xander.respond_to("#{@bot} elo for asdfasdfasdfasdf", @user)
      assert_equal "Hi <@#{@user}> I couldn’t find asdfasdfasdfasdf on guardian.gg.", response.text
    end
  end

  def test_elo_error_response
    VCR.use_cassette('membership_error') do
      response = @xander.respond_to("#{@bot} elo for /", @user)
      assert_equal "Hi <@#{@user}> I couldn’t find / on guardian.gg.", response.text
    end
  end

  def test_gamemode_elo_not_found
    VCR.use_cassette('elo_game_mode_not_found') do
      response = @xander.respond_to("rift elo for kurzinator #{@bot}", @user)
      assert_equal "Hi <@#{@user}> kurzinator's elo for rift is: *couldn’t find one*.", response.text
    end
  end

  def test_slack_profile_empty
    VCR.use_cassette('slack_profile_empty') do
      response = @xander.respond_to("my elo #{@bot}", @user)
      assert_equal "Hi <@#{@user}> I can't get your gamertag. Please add a profile title. Visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: yourgamertag` or `XB1: yourgamertag`)", response.text
    end
  end

  def test_slack_title_empty
    VCR.use_cassette('slack_title_empty') do
      response = @xander.respond_to("my elo #{@bot}", @user)
      assert_equal "Hi <@#{@user}> I don't know your gamertag. Your profile title on slack is empty. Visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: yourgamertag` or `XB1: yourgamertag`)", response.text
    end
  end

  def test_slack_title_wrong_format
    VCR.use_cassette('slack_title_wrong_format') do
      response = @xander.respond_to("#{@bot} my elo", @user)
      assert_equal "Hi <@U0TUWEY6R> I don't know your gamertag. Your profile title on slack is `wpp31`. Visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: yourgamertag` or `XB1: yourgamertag`)", response.text
    end
  end

  def test_gg_membership_failed
    VCR.use_cassette('gg_membership_failed') do
      response = @xander.respond_to('<@botid> my elo', @user)
      assert_equal "Hi <@U0TUWEY6R> I couldn’t find you on guardian.gg. Make sure your gamertag is correct.", response.text
    end
  end

  def test_gg_elo_gamemode_empty
    VCR.use_cassette('gg_elo_for_game_mode_empty') do
      response = @xander.respond_to("#{@bot} my elo", @user)
      assert_equal "Hi <@U0TUWEY6R> I couldn’t get a trials elo for you on guardian.gg.", response.text
    end

    VCR.use_cassette('gg_elo_for_game_mode_empty') do
      response = @xander.respond_to("#{@bot} my rift elo", @user)
      assert_equal "Hi <@U0TUWEY6R> I couldn’t get a rift elo for you on guardian.gg.", response.text
    end
  end

  def test_if_two_membership_ids_from_gg
    VCR.use_cassette('both_platforms') do
      response = @xander.respond_to("#{@bot} trials elo for scssquatch", @user)
      assert_equal "Hi <@#{@user}> scssquatch's elo for trials is: *1579* (PSN) *1704* (XBOX).", response.text
    end

    VCR.use_cassette('both_platforms_myelo') do
      response = @xander.respond_to("#{@bot} my elo", @user)
      assert_equal "Hi <@#{@user}> your trials elo is: *1579* (PSN) *1704* (XBOX).", response.text
    end
  end

  def test_trials_maps_regular
    [
      "#{@bot} trials map",
      "#{@bot} maps",
      "#{@bot} whats the map?",
      "#{@bot} trials map dude",
      "#{@bot} gimme trials map"
    ].each do |msg|
      VCR.use_cassette('trials_map') do
        response = @xander.respond_to(msg, @user)
        assert_equal "Map is _Widow's Court_ (3/18/2016) http://db.destinytracker.com/activities/2332037858-widows-court. Callouts are here: http://mattaltepeter.com/destiny/maps/. Good luck!", response.text
      end
    end
  end

  def test_trials_maps_rotating
    VCR.use_cassette('trials_map_rotating') do
      response = @xander.respond_to("#{@bot} trials map", @user)
      assert_equal "Map is _Random / Rotating Maps_ (4/1/2016) . Callouts are here: http://mattaltepeter.com/destiny/maps/. Good luck!", response.text
    end
  end

  def test_if_trials_map_request_empty
    [
      "#{@bot} trials map",
      "#{@bot} maps",
      "#{@bot} whats the map?",
      "#{@bot} trials map dude",
      "#{@bot} gimme trials map"
    ].each do |msg|
      response = @xander.respond_to(msg, @user)
      assert_equal "(╯°□°）╯︵ ┻━┻", response.text
    end
  end

  def test_streamers_response
    [
      "#{@bot} have some streamers for me?",
      "#{@bot} good streamers",
      "#{@bot} twitch streamers"
    ].each do |msg|
      response = @xander.respond_to(msg, @user)
      assert_equal 'Here are some pretty cool streamers: https://usecanvas.com/imbriaco/low-sodium-streamers/4OuRsTOn8PithLvegHp3Df', response.text
    end
  end

  def test_faction
    [
      "#{@bot} what is the best faction?",
      "What is your faction #{@bot}"
    ].each do |msg|
      response = @xander.respond_to(msg, @user)
      assert_equal 'My allegiance is with Dead Orbit. All hail Severus Snape. :metal:', response.text
    end
  end

  def test_daily_challenge
    [
      "#{@bot} daily challenge",
      "#{@bot} DAILY challenge",
      "#{@bot} help with daily"
    ].each do |msg|
      response = mock()
      response.expects(:text).returns('sentence')
      Response::Daily.expects(:new).returns(response)

      assert_equal 'sentence', @xander.respond_to(msg, @user).text
    end
  end

  def test_rant
    [
      "#{@bot} whats your problem",
      "this is your fault #{@bot}",
      "I blame #{@bot}",
      "#{@bot} is salty"
    ].each do |msg|
      response = mock()
      response.expects(:text).returns('sentence')
      Response::Rant.expects(:new).returns(response)

      assert_equal 'sentence', @xander.respond_to(msg, @user).text
    end
  end

  def test_nice
    [
      "#{@bot} behave",
      "say YOUR're sorry! #{@bot}",
      "be nice #{@bot}",
      "#{@bot} sry"
    ].each do |msg|
      response = mock()
      response.expects(:text).returns('sentence')
      Response::Nice.expects(:new).returns(response)

      assert_equal 'sentence', @xander.respond_to(msg, @user).text
    end
  end

  def test_thx
    [
      "thanks #{@bot}",
      "thx #{@bot}",
      "#{@bot} thank you"
    ].each do |msg|
      response = mock()
      response.expects(:text).returns('no worries')
      Response::Thx.expects(:new).returns(response)

      assert_equal 'no worries', @xander.respond_to(msg, @user).text
    end
  end

  def test_morning
    [
      "morning! #{@bot}",
      "good morning #{@bot}",
      "mornin #{@bot}"
    ].each do |msg|
      response = mock()
      response.expects(:text).returns('morning')
      Response::Morning.expects(:new).returns(response)

      assert_equal 'morning', @xander.respond_to(msg, @user).text
    end

  end

  def test_crucible_talk
    [
      "#{@bot} what do you think about the crucible?",
      "crucible #{@bot}",
      "state of pvp #{@bot}"
    ].each do |msg|
      response = mock()
      response.expects(:text).returns('meh')
      Response::Crucible.expects(:new).returns(response)

      assert_equal 'meh', @xander.respond_to(msg, @user).text
    end
  end

  def test_default_action
    [
      "#{@bot} what the heck?",
      "#{@bot} stop it",
      "#{@bot} jibber jabber"
    ].each do |msg|
      response = mock('default')
      response.expects(:text).returns('dont get it')
      Response::Default.expects(:new).returns(response)

      assert_equal 'dont get it', @xander.respond_to(msg, @user).text
    end
  end

  def test_where_is_xur
    [
      "#{@bot} where is xur?",
      "#{@bot} wher's xur",
      "#{@bot} where is xur at?",
      "#{@bot} wheres xur???",
      "#{@bot} xur's location",
      "#{@bot} where is xur located?"
    ].each do |msg|
      VCR.use_cassette('xur_location') do
        response = @xander.respond_to(msg, @user)
        assert_equal "Xur's Location (Apr 1 – Apr 3, 2016): http://www.destinylfg.com/assets/findxur/xur-location-speaker-north.png", response.text
      end
    end
  end

  def test_where_is_xur_reef
    VCR.use_cassette('xur_location_reef') do
      response = @xander.respond_to("#{@bot} where is xur", @user)
      assert_equal "Xur's Location (Apr 15 – Apr 17, 2016): Xur is in the Reef. After arrival: turn right, go down the stairs, look right and he is through the open door.", response.text
    end
  end

  def test_where_is_xur_error
    [
      "#{@bot} where is xur?",
      "#{@bot} wher's xur",
      "#{@bot} where is xur at?",
      "#{@bot} wheres xur???"
    ].each do |msg|
      VCR.use_cassette('xur_location_error') do
        response = @xander.respond_to(msg, @user)
        assert_equal "(╯°□°）╯︵ ┻━┻", response.text
      end
    end
  end

  def test_xur_inventory
    [
      "#{@bot} what is xur selling?",
      "#{@bot} xurs inventory?",
      "#{@bot} xurs stuff",
      "#{@bot} whats xur selling?"
    ].each do |msg|
      VCR.use_cassette('xur_inventory') do
          response = @xander.respond_to(msg, @user)
          a = "Xur's Inventory (Apr 1 – Apr 3, 2016):
_The Taikonaut_: http://www.destinydb.com/items/591060261-the-taikonaut
_Sealed Ahamkara Grasps_: http://www.destinydb.com/items/2217280775-sealed-ahamkara-grasps
_Apotheosis Veil_: http://www.destinydb.com/items/1519376145-apotheosis-veil
_Exotic Gauntlet Engram_: http://www.destinydb.com/items/111626780-exotic-engram
_Legacy Chest Engram_: http://www.destinydb.com/items/27147831-exotic-engram"
        assert_equal a, response.text
      end
    end
  end

  def test_channel_join
    response = @xander.respond_to('<@U0TUN6XHS|xander> has joined the channel', @user, 'C0CPS1MLH', 'channel_join')
    assert_equal "<@#{@user}> :notes: _\"We are programmed to receive. You can check-out any time you like, But you can never leave!\"_ :notes:", response.text
  end
end
