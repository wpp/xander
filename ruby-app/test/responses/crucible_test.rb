require_relative '../test_helper'

class CrucibleTest < Minitest::Test
  def test_trigger
    [
      "#{@bot} what do you think about the crucible?",
      "crucible #{@bot}",
      "state of pvp #{@bot}"
    ].each do |msg|
      assert Response::Crucible.triggered_by?(msg)
    end
  end
end
