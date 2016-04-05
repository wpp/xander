require 'test_helper'
require_relative '../lib/gamertag'

class GamertagTest < Minitest::Test
  def test_parsing
    gamertags = JSON.parse(File.read(File.join('test', 'fixtures', 'gamertags.json')))
    gamertags.each do |gt|
      gamertag = Gamertag.parse(gt['title'])
      assert_equal gt['gamertag'], gamertag
    end
  end
end
