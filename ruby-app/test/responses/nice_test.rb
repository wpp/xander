require_relative '../test_helper'

class NiceTest < Minitest::Test
  def test_trigger
    [
      "#{@bot} behave",
      "say YOUR're sorry! #{@bot}",
      "be nice #{@bot}",
      "#{@bot} sry"
    ].each do |msg|
      assert Response::Nice.triggered_by?(msg)
    end
  end
end
