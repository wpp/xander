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

  def test_xur_inventory_when_he_is_gone
    VCR.use_cassette('xur_inventory_gone') do
      response = @xander.respond_to("#{@bot} xurs inventory?", @user)
      assert_equal "Hi <@#{@user}> Xur hasn't arrived yet.", response.text
      assert_equal [], response.attachments
    end
  end

  def test_xur_inventory_when_he_is_there
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
              "fallback" => "Xur's Inventory: Plasma Drive, \"Emerald Coil\", Heavy Ammo Synthesis, Three of Coins, Glass Needles, Mote of Light, Twilight Garrison, Mask of the Third Man, Apotheosis Veil, Bad Juju, Legacy Engram",
              "text" => "Xur's Inventory",
              "thumb_url" => "https://pbs.twimg.com/profile_images/525558766180118528/hyDrezNf_400x400.png",
              "fields" =>
              [
                {"title"=>"Plasma Drive",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=1880070441|View in armory>",
                 "short"=>true},
                {"title"=>"\"Emerald Coil\"",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=1880070440|View in armory>",
                 "short"=>true},
                {"title"=>"Heavy Ammo Synthesis",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=211861343|View in armory>",
                 "short"=>true},
                {"title"=>"Three of Coins",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=417308266|View in armory>",
                 "short"=>true},
                {"title"=>"Glass Needles",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=2633085824|View in armory>",
                 "short"=>true},
                {"title"=>"Mote of Light",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=937555249|View in armory>",
                 "short"=>true},
                {"title"=>"Twilight Garrison",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=3921595523|View in armory>",
                 "short"=>true},
                {"title"=>"Mask of the Third Man",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=1520434779|View in armory>",
                 "short"=>true},
                {"title"=>"Apotheosis Veil",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=1519376145|View in armory>",
                 "short"=>true},
                {"title"=>"Bad Juju",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=1177550374|View in armory>",
                 "short"=>true},
                {"title"=>"Legacy Engram",
                 "value"=>"<https://www.bungie.net/en/armory/Detail?item=3149602403|View in armory>",
                 "short"=>true}
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
