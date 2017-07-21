require_relative '../test_helper'

class CloudTest < Minitest::Test
  def test_trigger
    [
      'Cloud IX would be a better name for a headset',
      'HyperX Cloud Gaming Headset for PC/PS4/Mac/Mobile',
      'HyperX Cloud Gaming Headset for PC/PS4/Mac/Mobile',
      'in the cloud',
      'in the icloud'
    ].each do |msg|
      assert Response::Cloud.triggered_by?(msg)
    end
  end

  def test_text_response
    assert_equal 'Butt IX would', Response::Cloud.new('Cloud IX would' ).text
    assert_equal 'in the butt', Response::Cloud.new('in the cloud').text
    assert_equal 'in the iButt', Response::Cloud.new('in the iCloud').text
  end
end
