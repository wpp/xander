require_relative '../test_helper'

class XurLocationTest < Minitest::Test
  def setup
    @client = Slack::RealTime::Client.new
    selfm = mock()
    selfm.expects(:id).returns('botid').at_least_once
    @client.expects(:self).returns(selfm).at_least_once
    @xander = Xander.new(@client)
    @user   = 'U0TUWEY6R'
    @bot    = '<@botid>'
  end

  def test_where_is_xur
    [
      "#{@bot} where is xur?",
      "#{@bot} wher's xur",
      "#{@bot} Where’s xur?",
      "#{@bot} where is xur at?",
      "#{@bot} wheres xur???",
      "#{@bot} xur's location",
      "#{@bot} xur location",
      "#{@bot} where is xur located?"
    ].each do |msg|
      VCR.use_cassette('xur_location') do
        response = @xander.respond_to(msg, @user)
        assert_equal "Hi <@#{@user}> you asked for Xur's location:", response.text

        expected_attachment = [
            {
                "fallback" => "Xur's Location (Apr 1 – Apr 3, 2016): http://www.destinylfg.com/assets/findxur/xur-location-speaker-north.png",
                "title" => "Xur's Location (Apr 1 – Apr 3, 2016)",
                "title_link" => "http://www.destinylfg.com/findxur/",
                "thumb_url"=>"https://pbs.twimg.com/profile_images/525558766180118528/hyDrezNf_400x400.png",
                "text" => "According to DestinyLFG, Xur should be here:",
                "image_url" => "http://www.destinylfg.com/assets/findxur/xur-location-speaker-north.png",
                "color" => "#FFCE1F"
            }
        ]

        assert_equal expected_attachment, response.attachments
      end
    end
  end

  def test_where_is_xur_reef
    VCR.use_cassette('xur_location_reef') do
      response = @xander.respond_to("#{@bot} where is xur", @user)
      assert_equal "Hi <@#{@user}> you asked for Xur's location:", response.text

      expected_attachment = [
          {
              "fallback" => "Xur's Location (Apr 15 – Apr 17, 2016): Xur is in the Reef. After arrival: turn right, go down the stairs, look right and he is through the open door.",
              "title" => "Xur's Location (Apr 15 – Apr 17, 2016)",
              "title_link" => "http://www.destinylfg.com/findxur/",
              "thumb_url"=>"https://pbs.twimg.com/profile_images/525558766180118528/hyDrezNf_400x400.png",
              "text" => "According to DestinyLFG Xur is in the Reef. After arrival: turn right, go down the stairs, look right and he is through the open door.",
              "image_url" => "",
              "color" => "#FFCE1F"
          }
      ]

      assert_equal expected_attachment, response.attachments
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
end
