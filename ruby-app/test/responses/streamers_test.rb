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
    assert_equal "I'm not gonna talk about SRL.", Response::Srl.new.text
  end
end
