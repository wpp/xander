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
end
