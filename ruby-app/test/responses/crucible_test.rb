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

  def test_text_response
    mock_sentences
    assert_equal 'yolo', Response::Crucible.new(1, 2, 3).text
  end
end
