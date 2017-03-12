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
# groups = client.web_client.groups_list.groups

count = 1000

channels.each do |channel|
  puts channel.name.to_s
  channel_history = []
  ts = 318_297_600
  response = OpenStruct.new(has_more: true)

  while response.has_more
    response = client.web_client.channels_history(channel: channel.id, count: count, oldest: ts)
    # response = client.web_client.groups_history(channel: channel.id, count: count, oldest: ts)
    messages = response.messages
    channel_history += messages.reverse
    ts = messages[0].ts
  end

  puts "History: #{channel_history.count} messages."
  File.open("dictionaries/#{channel.name}.txt", 'w') do |f|
    f.write(channel_history.map(&:text).join("\n"))
  end
end
