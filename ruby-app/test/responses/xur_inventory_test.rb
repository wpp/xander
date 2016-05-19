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

  def test_xur_inventory
    [
      "#{@bot} what is xur selling?",
      "#{@bot} xurs inventory?",
      "#{@bot} xurs stuff",
      "#{@bot} whats xur selling?"
    ].each do |msg|
      VCR.use_cassette('xur_inventory') do
          response = @xander.respond_to(msg, @user)
          expected_attachment = [
            {
              "fallback" => "Xur's Inventory: http://www.destinylfg.com/findxur/",
              "text" => "<http://www.destinylfg.com/findxur/|Xur's Inventory> (Apr 1 – Apr 3, 2016)",
              "thumb_url" => "https://pbs.twimg.com/profile_images/525558766180118528/hyDrezNf_400x400.png",
              "fields" => [
                  {
                    "title" => "The Taikonaut",
                    "value" => "<http://www.destinydb.com/items/591060261-the-taikonaut|Inspect>",
                    "short" => true
                  },
                  {
                    "title" => "Sealed Ahamkara Grasps",
                    "value" => "<http://www.destinydb.com/items/2217280775-sealed-ahamkara-grasps|Inspect>",
                    "short" => true
                  },
                  {
                    "title" => "Apotheosis Veil",
                    "value" => "<http://www.destinydb.com/items/1519376145-apotheosis-veil|Inspect>",
                    "short" => true
                  },
                  {
                    "title" => "Exotic Gauntlet Engram",
                    "value" => "<http://www.destinydb.com/items/111626780-exotic-engram|Inspect>",
                    "short" => true
                  },
                  {
                    "title" => "Legacy Chest Engram",
                    "value" => "<http://www.destinydb.com/items/27147831-exotic-engram|Inspect>",
                    "short" => true
                  }
              ],
              "color" => "#FFCE1F"
            }
          ]

        assert_equal "Hi <@#{@user}> you asked for Xur's inventory:", response.text
        assert_equal expected_attachment, response.attachments
      end
    end
  end
end
