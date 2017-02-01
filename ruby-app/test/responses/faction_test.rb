require_relative '../test_helper'

class FactionTest < Minitest::Test
  def test_trigger
    [
      "what is the best faction?",
      "What is your faction"
    ].each { |msg| assert Response::Faction.triggered_by?(msg) }
  end

  def test_text_response
    response = Response::Faction.new('what is your faction')
    assert_equal(
      'My allegiance is with Dead Orbit. All hail Severus Snape. :metal:',
      response.text
    )
  end
end
