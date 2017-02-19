require_relative '../test_helper'

class RantTest < Minitest::Test
  def test_trigger
    [
      "#{@bot} whats your problem",
      "this is your fault #{@bot}",
      "I blame #{@bot}",
      "#{@bot} is salty"
    ].each do |msg|
      assert Response::Rant.triggered_by?(msg)
    end
  end
end
