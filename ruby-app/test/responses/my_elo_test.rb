require_relative '../test_helper'

class MyEloTest < Minitest::Test
  def setup
    @client = Slack::RealTime::Client.new
    selfm = mock()
    selfm.expects(:id).returns('botid').at_least_once
    @client.expects(:self).returns(selfm).at_least_once
    @xander = Xander.new(@client)
    @user   = 'U0TUWEY6R'
    @bot    = '<@botid>'
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

  def test_if_two_membership_ids_from_gg
    VCR.use_cassette('both_platforms_myelo') do
      response = @xander.respond_to("#{@bot} my elo", @user)
      assert_equal "Hi <@#{@user}> your trials elo is: *1579* (PSN) *1704* (XBOX).", response.text
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

  def test_slack_profile_empty
    VCR.use_cassette('slack_profile_empty') do
      response = @xander.respond_to("my elo #{@bot}", @user)
      assert_response "Hi <@#{@user}>! I can't get your gamertag. Please add a profile title. Visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: yourgamertag` or `XB1: yourgamertag`)", response.text
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
end
