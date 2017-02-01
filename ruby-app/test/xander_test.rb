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
      'Cool. What’s 13 strange coins anyway. :)',
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

  def test_responds_to_at_mentions
    [
      "#{@bot} hi",
      "#{@bot} what do you think?",
      "maybe we can ask #{@bot}",
      "#{@bot}: what do you say????"
    ].each do |text|
      Response::Default.expects(:new)
      @xander.respond_to(text, @user)
    end
  end

  def test_responds_to_channel_join
    response = @xander.respond_to('<@U0TUN6XHS|xander> has joined the channel', @user, 'C0CPS1MLH', 'channel_join')
    assert_equal "<@#{@user}> :notes: _\"We are programmed to receive. You can check-out any time you like, But you can never leave!\"_ :notes:", response.text
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
end
