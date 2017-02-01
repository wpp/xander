require 'sqlite3'
require 'nokogiri'
require 'open-uri'
require_relative 'markov_chain'
require_relative 'gg'
require_relative 'gamertag'
require_relative 'responses'
require_relative 'greeting'

class Xander
  attr_reader :client, :responses

  def initialize(client)
    @client = client
    @responses = get_responses
  end

  def respond_to(message, user, channel='', subtype='')
    @at_bot ||= /<@#{client.self.id}>:?/
    if message =~ @at_bot
      message = message.gsub(@at_bot, '').lstrip.downcase
      get_response_for(message, user)
    elsif channel.respond_to?(:first) && (channel.first == 'D')
      get_response_for(message.downcase, user)
    elsif subtype == 'channel_join' && channel == 'C0CPS1MLH'
      Response::Bungie.new(user)
    elsif Response::Table.triggered_by?(message)
      Response::Table.new
    else
      nil
    end
  end

  def get_response_for(message, user)
    responses.each do |response|
      if response.triggered_by?(message)
        return response.new(message, user, client)
      end
    end
    Response::Default.new
  end

  private

  def get_responses
    Response.constants.map do |c|
      const = Response.const_get(c)
      const if const.is_a?(Class)
    end
  end
end
