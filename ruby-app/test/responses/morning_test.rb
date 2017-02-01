require_relative '../test_helper'

class MorningTest < Minitest::Test
  def test_trigger
    [
      'morning!',
      'good morning',
      'mornin'
    ].each { |msg| assert Response::Morning.triggered_by?(msg) }
  end
end
