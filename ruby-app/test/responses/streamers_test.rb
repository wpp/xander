require_relative '../test_helper'

class SrlTest < Minitest::Test
  def test_trigger
    [
      'srl elo',
      'how many races',
      'racing'
    ].each { |msg| assert Response::Srl.triggered_by?(msg) }
  end

  def test_text_response
    response = Response::Srl.new
    assert_equal "I'm not gonna talk about SRL.", response.text
  end
end
