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

  def test_text_response
    mock_sentences
    assert_equal 'yolo', Response::Daily.new(1,2,3).text
  end
end
