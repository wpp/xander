require_relative '../test_helper'

class TableTest < Minitest::Test
  def setup
    @client = Slack::RealTime::Client.new
    selfm = mock()
    selfm.expects(:id).returns('botid').at_least_once
    @client.expects(:self).returns(selfm).at_least_once
    @xander = Xander.new(@client)
    @user   = 'U0TUWEY6R'
    @bot    = '<@botid>'
  end


  def test_responds_to_flipped_tables
    [
      '(╯°□°）╯︵ ┻━┻',
      '(┛◉Д◉)┛彡┻━┻',
      '(ﾉ≧∇≦)ﾉ ﾐ ┸━┸',
      '(ノಠ益ಠ)ノ彡┻━┻',
      '(╯ರ ~ ರ）╯︵ ┻━┻',
      '(┛ಸ_ಸ)┛彡┻━┻',
      '(ﾉ´･ω･)ﾉ ﾐ ┸━┸',
      '(ノಥ,_｣ಥ)ノ彡┻━┻',
      '(┛✧Д✧))┛彡┻━┻',
      '(┛✧Д✧))┛彡┻━┻ duck this',
      'I hate bungo!!! pls fix stuff (┛✧Д✧))┛彡┻━┻',
    ].each do |message|
      response =  @xander.respond_to(message, @user)
      assert_equal '┬─┬ノ( º _ ºノ)', response.text
      assert_equal [], response.attachments
    end
  end
end
