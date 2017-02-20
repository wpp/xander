require 'slack'
require 'byebug'

Slack.configure do |config|
  if ENV['SLACK_API_TOKEN']
    config.token = ENV['SLACK_API_TOKEN']
    puts 'Using auth token from ENV'
  else
    puts 'Missing slack token'
    exit
  end
end

client = Slack::RealTime::Client.new
channels = client.web_client.channels_list.channels

channels.each do |channel|
  puts "#{channel.name}"
  messages = client.web_client.channels_history({ channel: channel.id, count: 1000 }).messages

  puts "Got: #{messages.count} messages."
  File.open("dictionaries/#{channel.name}.txt", 'w') { |f| f.write(messages.map(&:text).join("\n")) }
end
