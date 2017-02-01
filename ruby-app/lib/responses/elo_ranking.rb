module Response
  class EloRanking < Base
    attr_reader :message, :user, :client

    COLORS = {
      'trials' => '#D2D42D',
      'iron banner' => '#293D34'
    }

    THUMB_URLS = {
      'trials' => 'https://www.bungie.net/img/profile/avatars/bungiedayav4.jpg?cv=3727043970&av=1624003925',
      'iron banner' => 'https://www.bungie.net/common/destiny_content/icons/95ca457b1cbcf7e392d1fc6bc9095e53.jpg'
    }

    def initialize(message, user, client)
      super()
      @message = message
      @user = user
      @client = client
      @gamertags = []
      @elos = []
      get_mode
      get_gamertags
      get_membership_ids
      @text = get_text
    end

    def self.triggered_by?(message)
      message =~ /elo ranking/i
    end

    def get_text
      if @slack_users.length > 5
        "Hi <@#{user}> only 5 users are supported for a elo ranking."
      elsif @gamertags.empty?
        "Hi <@#{user}> I can't get any gamertags for the users you provided. Make sure their title on slack is filled out. #{change_instructions}"
      else
        "Hi <@#{user}>, "
      end
    end

    def attachments
      # TODO ewww
      if @slack_users.length > 5 || @gamertags.empty?
        return []
      end

      text_part = ''
      @elos.sort_by { |elo| elo[:elo] }.reverse.each_with_index do |elo, i|
        link = "http://guardian.gg/en/profile/#{elo[:platform]}/#{elo[:gamertag]}/#{GG::MODES[@mode]}"
        if i == 0
          text_part += "#{i+1}. <#{link}|#{elo[:gamertag]}>: #{elo[:elo]} :medal:\n"
        else
          text_part += "#{i+1}. <#{link}|#{elo[:gamertag]}>: #{elo[:elo]}\n"
        end
      end

      color = COLORS[@mode] || '#97322D'
      thumb_url = THUMB_URLS[@mode] || 'https://www.bungie.net/common/destiny_content/icons/361235bb0cd9ae75ba98e77c1971db0f.jpg'

      [
        {
            "fallback"  => "Elo ranking for _#{@mode}_:",
            "pretext"   => "Elo ranking for _#{@mode}_:",
            "text"      => text_part.chomp("\n"),
            "color"     => color,
            "thumb_url" => thumb_url,
            "mrkdwn_in" => [
                "text","pretext"
            ]
        }
      ]
    end

    private
      def get_mode
        @mode, eloa, fora, gamertag = message.split(' ')
        @mode = 'trials'
        @mode = 'iron banner' if message.include?('iron banner')
        GG::MODES.keys.each { |gg_mode| @mode = gg_mode if message.include?(gg_mode) }
      end

      def get_gamertags
        @slack_users = message.scan(/<@\w{9}>/i)
        mode, eloa, fora, gamertag = message.split(' ')
        if @slack_users.any? && @slack_users.length <= 5
          @slack_users.each do |slack_user|
            @slack_user = client.web_client.users_info(user: slack_user.gsub(/\W+/i, '').upcase).user
            @gamertags << Gamertag.parse(@slack_user.profile.title)
          end
        end
      end

      def get_membership_ids
        if @gamertags.any?
          @gamertags.each do |gamertag|
            @gg_user = GG::User.new(gamertag: gamertag)
            @gg_user.get_membership_ids
            if @gg_user.membership_ids.empty?
              "Couldn’t find #{gamertag} on guardian.gg."
            else
              get_elos(gamertag)
            end
          end
        end
      end

      def get_elos(gamertag)
        @gg_user.membership_ids.each do |mid|
          if @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[@mode] }.empty?
            @elos << { gamertag: gamertag, platform: mid[:platform_id], elo: 0000 }
          else
            elo = @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[@mode] }.first['elo'].round
            @elos << { gamertag: gamertag, platform: mid[:platform_id], elo: elo }
          end
        end
      end

      def change_instructions
        if @client.respond_to?(:team) && @client.team.respond_to?(:domain)
          domain = @client.team.domain
        else
          domain = 'testing'
        end
        "They need to visit https://#{domain}.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: gamertag` or `XB1: gamertag`)"
      end
  end
end
