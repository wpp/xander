require 'slack'
require 'logger'
require_relative 'lib/xander'
require 'byebug'

# Bot is the first place of contact with user data.
class Bot
  attr_reader :logger, :client, :xander

  def initialize
    # TODO: replace this config setup with config.yml
    Slack.config.token = ENV['SLACK_API_TOKEN'] || File.read('.testbot').chomp
    @logger = Logger.new(ENV['SLACK_API_TOKEN'] ? 'log/xander.log' : STDOUT)

    @client = Slack::RealTime::Client.new
    @client.on(:hello, &method(:on_hello))
    @client.on(:message, &method(:on_message))

    @xander = Xander.new(@client)
  end

  def start
    client.start!
  end

  private

  def on_hello(*)
    logger.info(
      "Connected as #{client.self.name} to #{client.team.domain}.slack.com"
    )
  end

  def on_message(data)
    return unless might_respond_to?(data)
    response = get_response_for(data)
    respond_with(response, data) if response
  end

  # Before we decide to hand the data to xander, guard if he'd even
  # be able to respond.
  # TODO: find out when data doesn't have a text?
  def might_respond_to?(data)
    data.respond_to?(:text) && !data.text.nil? && (data.user != client.self.id)
  end

  # unify what respond_to and might_respond_to? currently are
  # find one place where we decide to respond to a message
  def get_response_for(data)
    xander.respond_to(data.text, data.user, data.channel, data.subtype)
  end

  def respond_with(response, data)
    logger.info "#{data.user} message: '#{data.text}'"
    logger.info "response: '#{response.text}'"
    client.web_client.chat_postMessage(text: response.text,
                                       attachments: response.attachments,
                                       channel: data.channel,
                                       as_user: true)
  end
end

Bot.new.start
