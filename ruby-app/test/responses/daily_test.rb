require_relative '../test_helper'

class DailyTest < Minitest::Test
  def test_trigger
    [
      "#{@bot} daily challenge",
      "#{@bot} DAILY challenge",
      "#{@bot} help with daily"
    ].each do |msg|
      assert Response::Daily.triggered_by?(msg)
    end
  end
end
