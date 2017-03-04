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

  def test_text_response
    mock_sentence
    assert_equal 'yolo', Response::Nice.new(1,2,3).text
  end
end
