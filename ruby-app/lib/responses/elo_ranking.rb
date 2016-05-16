module Response
  class EloRanking
    attr_reader :message, :user, :client, :attachments, :text

    def initialize(message, user, client)
      @message = message
      @user = user
      @client = client
      @gamertags = []
      @text = 'Hi user'
      @attachments = []
      get_mode
      get_gamertags
    end

    def text
      get_membership_ids
    end

    private
      def get_mode
        @mode, eloa, fora, gamertag = message.split(' ')
        @mode = 'trials'
        @mode = 'iron banner' if message.include?('iron banner')
        GG::MODES.keys.each { |gg_mode| @mode = gg_mode if message.include?(gg_mode) }
      end

      def get_gamertags
        slack_users = message.scan(/<@\w{9}>/i)
        mode, eloa, fora, gamertag = message.split(' ')
        if mode == 'elo'
          eloa, fora, gamertag = message.split(' ')
        end
        if message.include?('iron banner')
          eloa, fora, gamertag = message.gsub('iron banner', '').split(' ')
        end
        if slack_users.any?
          slack_users.each do |slack_user|
            @slack_user = client.web_client.users_info(user: slack_user.gsub(/\W+/i, '').upcase).user
            @gamertags << Gamertag.parse(@slack_user.profile.title)
          end
        end
      end

      def get_membership_ids
        @attachments = [
        {
            "fallback": "Elo Rankings for _trials_:",
            "pretext": "Elo rankings for _Trials_:",
"text": "1. <https://google.com|wpp>: 1230 :medal:\n2. <https://google.com|samsymons>: 1120\n3. <https://google.com|mehbor>: 1100\n4. <https://google.com|ollyc92>: 1020\n5. <https://google.com|sdchk>: 1000",
            "thumb_url": "https://www.bungie.net/common/destiny_content/icons/7b03d738903433a4bd1694e3af2570cf.png",
            "color": "#97322D",
            "mrkdwn_in": [
                "text","pretext"
            ]
        }
    ]
        response = ''
        if @gamertags.any?
          @gamertags.each do |gamertag|
            @gg_user = GG::User.new(gamertag: gamertag)
            @gg_user.get_membership_ids
            if @gg_user.membership_ids.empty?
              response += "Hi <@#{user}> I couldn’t find #{gamertag} on guardian.gg."
            else
              response += get_elos(gamertag)
            end
          end
        else
          title = @slack_user.profile.title.empty? ? 'empty' : "`#{@slack_user.profile.title}`"
          response = "Hi <@#{user}> I can't get a gamertag for #{@slack_user.name}. Her/His title on slack is #{title}. #{change_instructions}"
        end
        response
      end

      def get_elos(gamertag)
        elos = []
        @gg_user.membership_ids.each do |mid|
          if @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[@mode] }.empty?
            elos << { platform: mid[:platform_id], elo: 'couldn’t find one' }
          else
            elo = @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[@mode] }.first['elo'].floor
            elos << { platform: mid[:platform_id], elo: elo }
          end
        end
        if elos.length > 1
          elo_str = ""
          elos.each do |platform_elo|
            elo_str += " *#{platform_elo[:elo]}* (#{GG::PLATFORMS[platform_elo[:platform]]})"
          end
          "Hi <@#{user}> #{gamertag}'s elo for #{@mode} is:#{elo_str}."
        else
          "Hi <@#{user}> #{gamertag}'s elo for #{@mode} is: *#{elos.first[:elo]}*."
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
