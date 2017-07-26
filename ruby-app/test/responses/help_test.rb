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
      'Here is how I could help you out:',
      response.text
    )
  end
end
