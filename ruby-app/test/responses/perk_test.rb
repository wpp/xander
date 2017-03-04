require_relative '../test_helper'

class PerkTest < Minitest::Test
  def test_trigger
    [
      "#{@bot} perk quickdraw",
      "#{@bot} perks quickdraw",
      "#{@bot} quickdraw perk"
    ].each do |msg|
      assert Response::Perk.triggered_by?(msg)
    end
  end

  def test_text_response
    assert_equal 'Hi <@2> here is what I found for: *the dance*',
      Response::Perk.new('the dance',2,3).text
  end

  def test_attachment_response
    expected = [
      {'fallback' => 'Perk description for the dance',
        'fields' => [
          {'title' => 'The Dance',
            'value' => 'You move more quickly while aiming your weapon.'}
        ], 'color' => '#FFCE1F'}
    ]
    assert_equal expected, Response::Perk.new('the dance',2,3).attachments
  end
end
