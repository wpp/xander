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
    ].each do |message|
      response = mock('default')
      Response::Default.expects(:new).returns(response)

      assert @xander.respond_to(message, @user, 'D')
    end
  end


  def test_responds_to_channel_join
    response = @xander.respond_to('<@U0TUN6XHS|xander> has joined the channel', @user, 'C0CPS1MLH', 'channel_join')
    assert_equal "<@#{@user}> :notes: _\"We are programmed to receive. You can check-out any time you like, But you can never leave!\"_ :notes:", response.text
  end

  def test_elo_at_slack_user_no_gamertag
    VCR.use_cassette('elo_for_@rorith_no_gamertag') do
      response = @xander.respond_to("#{@bot} elo for <@U0PCXGYJX>", @user)
      assert_equal "Hi <@U0TUWEY6R> I can't get a gamertag for rorith. Her/His title on slack is `aaa`. They need to visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: gamertag` or `XB1: gamertag`)", response.text
      assert_equal [], response.attachments
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
      assert_equal [], response.attachments
    end
  end

  def test_faction
    [
      "#{@bot} what is the best faction?",
      "What is your faction #{@bot}"
    ].each do |msg|
      response = @xander.respond_to(msg, @user)
      assert_equal 'My allegiance is with Dead Orbit. All hail Severus Snape. :metal:', response.text
      assert_equal [], response.attachments
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

  def test_srl
    [
      "#{@bot} srl elo",
      "#{@bot} how many races",
      "#{@bot} racing"
    ].each do |msg|
      assert_equal "I'm not gonna talk about SRL.",
        @xander.respond_to(msg, @user).text
    end
  end
end
