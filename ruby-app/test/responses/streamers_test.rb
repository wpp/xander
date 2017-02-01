require_relative '../test_helper'

class StreamersTest < Minitest::Test
  def test_trigger
    [
      'have some streamers for me?',
      'good streamers',
      'twitch streamers'
    ].each { |msg| assert Response::Streamers.triggered_by?(msg) }
  end

  def test_text_response
    response = Response::Streamers.new('good stremers')
    assert_equal 'Here are some pretty cool streamers: https://usecanvas.com/imbriaco/low-sodium-streamers/4OuRsTOn8PithLvegHp3Df', response.text
  end
end
