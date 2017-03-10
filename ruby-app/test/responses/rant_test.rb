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

  def test_text_response
    mock_sentences
    assert_equal 'YOLO', Response::Rant.new(1, 2, 3).text
  end
end
