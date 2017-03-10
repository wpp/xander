require 'simplecov'
SimpleCov.start

require 'vcr'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'webmock/minitest'
require 'custom_assertions'
require 'byebug'
require 'slack'

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/slack'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
end

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN'] || File.read('.testbot').chomp
end

def mock_sentences
  dictionary = mock(generate_sentences: 'yolo')
  MarkovChain.expects(:new).returns(dictionary)
end

def mock_sentence
  dictionary = mock(generate_sentence: 'yolo')
  MarkovChain.expects(:new).returns(dictionary)
end

def fixture(name)
  JSON.parse(File.read("./test/fixtures/#{name}.json"))
end
