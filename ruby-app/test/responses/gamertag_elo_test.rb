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

  def test_elo_gamertag_unkown_gamemode
    VCR.use_cassette('elo_fo_samsymons') do
      response = @xander.respond_to("#{@bot} unkowngamemode elo for samsymons", @user)
      assert_equal "Hi <@#{@user}> samsymons's elo for trials is: *1535*.", response.text
    end
  end

  def test_elo_gamertag
    VCR.use_cassette('elo_fo_wpp31') do
      response = @xander.respond_to("#{@bot} elo for wpp31", @user)
      assert_equal "Hi <@#{@user}> wpp31's elo for trials is: *1215*.", response.text
    end

    VCR.use_cassette('elo_fo_samsymons') do
      response = @xander.respond_to("#{@bot} elo for samsymons", @user)
      assert_equal "Hi <@#{@user}> samsymons's elo for trials is: *1535*.", response.text
    end
  end

  def test_elo_at_slack_user
    VCR.use_cassette('elo_for_@rorith') do
      response = @xander.respond_to("#{@bot} elo for <@U0PCXGYJX>", @user)
      assert_equal "Hi <@#{@user}> Rorith__'s elo for trials is: *1369*.", response.text
    end
  end

  def test_elo_gamertag_and_gametype
    VCR.use_cassette('elo_fo_samsymons') do
      response = @xander.respond_to("rumble elo for samsymons #{@bot}", @user)
      assert_equal "Hi <@#{@user}> samsymons's elo for rumble is: *1314*.", response.text
    end

    VCR.use_cassette('elo_fo_kurzinator') do
      response = @xander.respond_to("rift elo for kurzinator #{@bot}", @user)
      assert_equal "Hi <@#{@user}> kurzinator's elo for rift is: *1143*.", response.text
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

  def test_if_two_membership_ids_from_gg
    VCR.use_cassette('both_platforms') do
      response = @xander.respond_to("#{@bot} trials elo for scssquatch", @user)
      assert_equal "Hi <@#{@user}> scssquatch's elo for trials is: *1579* (PSN) *1704* (XBOX).", response.text
    end
  end
end
