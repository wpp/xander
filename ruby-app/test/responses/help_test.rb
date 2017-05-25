require_relative '../test_helper'

class HelpTest < Minitest::Test
  def test_trigger
    [
      'help?',
      'man',
      'hlp',
      'hilfe',
      'help me',
      'hlp me',
      'list commands',
      'commands'
    ].each { |msg| assert Response::Help.triggered_by?(msg) }
  end

  def test_text_response
    response = Response::Help.new('what is your faction')
    assert_equal(
      'My allegiance is with Dead Orbit. All hail Severus Snape. :metal:',
      response.text
    )
  end
end
