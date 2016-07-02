require 'sqlite3'
require 'nokogiri'
require 'open-uri'
require_relative 'markov_chain'
require_relative 'gg'
require_relative 'gamertag'
require_relative 'responses'

class Xander
  THX           = /thanks?|thx/i
  MAPS          = /maps?/i
  RANT          = /rant|problem|fault|blame|salt/i
  NICE          = /apologi(s|z)e|behave|nice|sorry|sry/i
  PERK          = /perk/i
  DAILY         = /daily/i
  TABLE         = /┸━┸|┻━┻/i
  MY_ELO        = /^my *(\w|\s)* elo/i
  GT_ELO        = /elo for *\w*/i
  MORNING       = /(good\s)?morning?.*|yo slack-peeps/
  FACTION       = /faction/i
  CRUCIBLE      = /crucible|pvp/i
  STREAMERS     = /streamers|stream|twitch|twitch.tv/i
  ELO_RANKING   = /elo ranking/i
  XUR_LOCATION  = /(wher([\w\s'])+xur.*|xur.s location)/i
  XUR_INVENTORY = /.*xur.*(selling|inventory|stuff).*/i

  def initialize(client)
    @client = client
  end

  def respond_to(message, user, channel='', subtype='')
    @at_bot ||= /<@#{@client.self.id}>:?/
    if message =~ @at_bot
      message = message.gsub(@at_bot, '').lstrip.downcase
      get_response_for(message, user)
    elsif channel.respond_to?(:first) && (channel.first == 'D')
      get_response_for(message.downcase, user)
    elsif subtype == 'channel_join' && channel == 'C0CPS1MLH'
      Response::Bungie.new(user)
    elsif message =~ TABLE
      Response::Table.new
    else
      nil
    end
  end

  def get_response_for(message, user)
    case message
    when THX            then Response::Thx.new
    when MAPS           then Response::Maps.new
    when RANT           then Response::Rant.new
    when NICE           then Response::Nice.new
    when PERK           then Response::Perk.new(message, user)
    when DAILY          then Response::Daily.new
    when MY_ELO         then Response::MyElo.new(message, user, @client)
    when GT_ELO         then Response::GamertagElo.new(message, user, @client)
    when MORNING        then Response::Morning.new
    when FACTION        then Response::Faction.new
    when CRUCIBLE       then Response::Crucible.new
    when STREAMERS      then Response::Streamers.new
    when ELO_RANKING    then Response::EloRanking.new(message, user, @client)
    when XUR_LOCATION   then Response::XurLocation.new(user)
    when XUR_INVENTORY  then Response::XurInventory.new(user)
    else Response::Default.new
    end
  end
end
