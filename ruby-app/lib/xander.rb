require 'nokogiri'
require 'open-uri'
require_relative 'markov_chain'
require_relative 'gg'
require_relative 'gamertag'
require_relative 'actions'

class Xander
  THX           = /thanks?|thx/i
  MAPS          = /maps?/i
  RANT          = /rant|problem|fault|blame|salt/i
  NICE          = /apologi(s|z)e|behave|nice|sorry|sry/i
  DAILY         = /daily/i
  MY_ELO        = /^my *(\w|\s)* elo/
  GT_ELO        = /elo for *\w*/
  MORNING       = /(good\s)?morning?.*|yo slack-peeps/
  FACTION       = /faction/i
  CRUCIBLE      = /crucible|pvp/i
  STREAMERS     = /streamers|stream|twitch|twitch.tv/i
  XUR_LOCATION  = /wher(.|\s)+xur.*/i
  XUR_INVENTORY = /.*xur.*(selling|inventory|stuff).*/i

  def initialize(client)
    @client = client
  end

  def respond_to(message, user, dm=false)
    @at_bot ||= /<@#{@client.self.id}>:?/
    if message =~ @at_bot
      message = message.gsub(@at_bot, '').lstrip.downcase
      action = get_action(message, user)
      action.response
    elsif dm
      action = get_action(message.downcase, user)
      action.response
    else
      nil
    end
  end

  def get_action(message, user)
    case message
    when THX            then Action::Thx.new
    when MAPS           then Action::Maps.new
    when RANT           then Action::Rant.new
    when NICE           then Action::Nice.new
    when DAILY          then Action::Daily.new
    when MY_ELO         then Action::MyElo.new(message, user, @client)
    when GT_ELO         then Action::GamertagElo.new(message, user)
    when MORNING        then Action::Morning.new
    when FACTION        then Action::Faction.new
    when CRUCIBLE       then Action::Crucible.new
    when STREAMERS      then Action::Streamers.new
    when XUR_LOCATION   then Action::XurLocation.new
    when XUR_INVENTORY  then Action::XurInventory.new
    else Action::Default.new
    end
  end
end
