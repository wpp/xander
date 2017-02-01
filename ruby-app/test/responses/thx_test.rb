require_relative '../test_helper'

class ThxTest < Minitest::Test
  def test_trigger
    [
      'thanks',
      'thx',
      'thank you',
      'awwww thanks!!!!'
    ].each { |msg| assert Response::Thx.triggered_by?(msg) }
  end
end
