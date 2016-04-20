require 'slack'
require 'logger'
require_relative 'lib/xander'
require 'byebug'

logger = Logger.new(STDOUT)

Slack.configure do |config|
  if ENV['SLACK_API_TOKEN']
    config.token = ENV['SLACK_API_TOKEN']
    logger.info 'Using auth token from ENV'
  else
    config.token = File.read('.testbot').chomp
    logger.info 'Using .testbot token'
  end
end

client = Slack::RealTime::Client.new
xander = Xander.new(client)

client.on :hello do
  logger.info "Connected '#{client.self.name}' to https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  if data.respond_to?(:text) && !data.text.nil? && (data.user != client.self.id)
    response = xander.respond_to(data.text, data.user, data.channel, data.subtype)
    if response
      logger.info data.user
      logger.info data.text
      logger.info response
      client.web_client.chat_postMessage(channel: data.channel, text: response, as_user: true) if response
    end
  end
end

client.start!
