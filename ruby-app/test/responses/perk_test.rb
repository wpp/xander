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
                 Response::Perk.new('the dance', 2, 3).text
  end

  def test_attachment_response
    db = mock(execute: todo)
    SQLite3::Database.expects(:open).returns(db)
    expected = fixture('perk_response')
    assert_equal expected, Response::Perk.new('the dance', 2, 3).attachments
  end

  private

  # rubocop:disable all
  def todo
    [
      [-1344786163, "{\"perkHash\":2950181133,\"displayName\":\"The Dance\",\"displayDescription\":\"You move more quickly while aiming your weapon.\",\"displayIcon\":\"/common/destiny_content/icons/d82dd2ba48cb47af9aafb2d3ece42b73.png\",\"isDisplayable\":true,\"perkGroups\":{\"weaponPerformance\":64,\"impactEffects\":0,\"guardianAttributes\":1,\"lightAbilities\":0,\"damageTypes\":0},\"hash\":2950181133,\"index\":0}"],
      [2031840133, "{\"perkHash\":2031840133,\"displayName\":\"The Dance\",\"displayDescription\":\"You move more quickly while aiming your weapon.\",\"displayIcon\":\"/common/destiny_content/icons/d82dd2ba48cb47af9aafb2d3ece42b73.png\",\"isDisplayable\":true,\"hash\":2031840133,\"index\":0}"]
    ]
  end
end
