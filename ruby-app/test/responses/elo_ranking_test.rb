require_relative '../test_helper'

class EloRankingTest < Minitest::Test
  def setup
    @client = Slack::RealTime::Client.new
    selfm = mock()
    selfm.expects(:id).returns('botid').at_least_once
    @client.expects(:self).returns(selfm).at_least_once
    @xander = Xander.new(@client)
    @user = 'U0TUWEY6R'
    @bot = '<@botid>'
  end

  def test_elo_ranking
    expected_attachments =
    [
      {
        "fallback"  => "Elo ranking for _trials_:",
        "pretext"   => "Elo ranking for _trials_:",
        "text"      => "1. <http://guardian.gg/en/profile/2/Rorith__/14|Rorith__>: 1456 :medal:\n2. <http://guardian.gg/en/profile/2/samsymons/14|samsymons>: 1358\n3. <http://guardian.gg/en/profile/2/kurzinator/14|kurzinator>: 1200",
        "color"     => "#D2D42D",
        "thumb_url" =>"https://www.bungie.net/img/profile/avatars/bungiedayav4.jpg?cv=3727043970&av=1624003925",
        "mrkdwn_in" => [
            "text",
            "pretext"
        ]
      }
    ]

    VCR.use_cassette('elo_ranking') do
      response = @xander.respond_to("#{@bot} elo ranking for <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>", @user)
      assert_equal "Hi <@#{@user}>, ", response.text
      assert_equal expected_attachments, response.attachments
    end
  end

  def test_no_gamertags
    response = @xander.respond_to("#{@bot} elo ranking for ", @user)
    assert_equal "Hi <@#{@user}> I can't get any gamertags for the users you provided. Make sure their title on slack is filled out. They need to visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: gamertag` or `XB1: gamertag`)", response.text
  end

  def test_gamertags_empty
    VCR.use_cassette('elo_ranking_empty') do
      response = @xander.respond_to("#{@bot} elo ranking for drpeeprpr asdfasdfasdf", @user)
      assert_equal "Hi <@#{@user}> I can't get any gamertags for the users you provided. Make sure their title on slack is filled out. They need to visit https://testing.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: gamertag` or `XB1: gamertag`)", response.text
    end
  end

  def test_elo_rankings_gamemode
    expected_attachments =
    [
      {
        "fallback"  => "Elo ranking for _skirmish_:",
        "pretext"   => "Elo ranking for _skirmish_:",
        "text"      => "1. <http://guardian.gg/en/profile/2/Rorith__/9|Rorith__>: 1361 :medal:\n2. <http://guardian.gg/en/profile/2/samsymons/9|samsymons>: 1279\n3. <http://guardian.gg/en/profile/2/kurzinator/9|kurzinator>: 1190",
        "color"     => "#97322D",
        "thumb_url" =>"https://www.bungie.net/common/destiny_content/icons/361235bb0cd9ae75ba98e77c1971db0f.jpg",
        "mrkdwn_in" => [
            "text",
            "pretext"
        ]
      }
    ]

    VCR.use_cassette('elo_ranking_skirmish') do
      [
        "#{@bot} skirmish elo ranking for <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>",
        "#{@bot} elo ranking for skirmish for <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>",
        "#{@bot} elo ranking for skirmish <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>"
      ].each do |msg|
        response = @xander.respond_to(msg, @user)
        assert_equal "Hi <@#{@user}>, ", response.text
        assert_equal expected_attachments, response.attachments
      end
    end
  end

  def test_elo_ranking_iron_banner
    expected_attachments =
    [
      {
        "fallback"  => "Elo ranking for _iron banner_:",
        "pretext"   => "Elo ranking for _iron banner_:",
        "text"      => "1. <http://guardian.gg/en/profile/2/Rorith__/19|Rorith__>: 1200 :medal:\n2. <http://guardian.gg/en/profile/2/kurzinator/19|kurzinator>: 1200\n3. <http://guardian.gg/en/profile/2/samsymons/19|samsymons>: 1200",
        "color"     => "#293D34",
        "thumb_url" =>"https://www.bungie.net/common/destiny_content/icons/95ca457b1cbcf7e392d1fc6bc9095e53.jpg",
        "mrkdwn_in" => [
            "text",
            "pretext"
        ]
      }
    ]

    VCR.use_cassette('elo_ranking_iron_banner') do
      [
        "#{@bot} iron banner elo ranking for <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>",
        "#{@bot} elo ranking for iron banner for <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>",
        "#{@bot} elo ranking for iron banner <@U0CTT9QUD> <@U0CN05BCH> <@U0PCXGYJX>"
      ].each do |msg|
        response = @xander.respond_to(msg, @user)
        assert_equal "Hi <@#{@user}>, ", response.text
        assert_equal expected_attachments, response.attachments
      end
    end
  end

  def test_elo_ranking_with_missing_slack_title
    expected_attachments =
    [
      {
        "fallback"  => "Elo ranking for _iron banner_:",
        "pretext"   => "Elo ranking for _iron banner_:",
        "text"      => "1. <http://guardian.gg/en/profile/2/Rorith__/19|Rorith__>: 1200 :medal:\n2. <http://guardian.gg/en/profile/2/kurzinator/19|kurzinator>: 1200",
        "color"     => "#293D34",
        "thumb_url" =>"https://www.bungie.net/common/destiny_content/icons/95ca457b1cbcf7e392d1fc6bc9095e53.jpg",
        "mrkdwn_in" => [
            "text",
            "pretext"
        ]
      }
    ]

    VCR.use_cassette('elo_ranking_missing_slack_title') do
      [
        "#{@bot} iron banner elo ranking for <@U0R1E1F16> <@U0CN05BCH> <@U0PCXGYJX>",
        "#{@bot} elo ranking for iron banner for <@U0R1E1F16> <@U0CN05BCH> <@U0PCXGYJX>",
        "#{@bot} elo ranking for iron banner <@U0R1E1F16> <@U0CN05BCH> <@U0PCXGYJX>"
      ].each do |msg|
        response = @xander.respond_to(msg, @user)
        assert_equal "Hi <@#{@user}>, ", response.text
        assert_equal expected_attachments, response.attachments
      end
    end
  end

  def test_user_on_multiple_consoles
    expected_attachments =
    [
      {
        "fallback"  => "Elo ranking for _trials_:",
        "pretext"   => "Elo ranking for _trials_:",
        "text"      => "1. <http://guardian.gg/en/profile/2/Rorith__/14|Rorith__>: 1456 :medal:\n2. <http://guardian.gg/en/profile/2/scssquatch/14|scssquatch>: 1422\n3. <http://guardian.gg/en/profile/1/scssquatch/14|scssquatch>: 1419\n4. <http://guardian.gg/en/profile/2/ollyc92/14|ollyc92>: 1306\n5. <http://guardian.gg/en/profile/1/ollyc92/14|ollyc92>: 0",
        "color"     => "#D2D42D",
        "thumb_url" =>"https://www.bungie.net/img/profile/avatars/bungiedayav4.jpg?cv=3727043970&av=1624003925",
        "mrkdwn_in" => [
            "text",
            "pretext"
        ]
      }
    ]

    VCR.use_cassette('elo_ranking_multi_consoles') do
      [
        "#{@bot} trials elo ranking for <@U0HJX07TQ> <@U0EJB3153> <@U0PCXGYJX>",
        "#{@bot} elo ranking for trials for <@U0EJB3153> <@U0HJX07TQ> <@U0PCXGYJX>",
      ].each do |msg|
        response = @xander.respond_to(msg, @user)
        assert_equal "Hi <@#{@user}>, ", response.text
        assert_equal expected_attachments, response.attachments
      end
    end
  end

  def test_elo_ranking_user_limit
    [
      "#{@bot} trials elo ranking for <@U0HJX07TQ> <@U0EJB3153> <@U0PCXGYJX> <@U0HJX07TQ> <@U0HJX07TQ> <@U0HJX07TQ>"
    ].each do |msg|
      response = @xander.respond_to(msg, @user)
      assert_equal "Hi <@#{@user}> only 5 users are supported for a elo ranking.", response.text
      assert_equal [], response.attachments
    end
  end
end
