module Response
  class GamertagElo < Base
    attr_reader :message, :user, :client

    def initialize(message, user, client)
      super()
      @message = message
      @user = user
      @client = client
      get_mode
      get_gamertag
      @text = get_membership_ids
    end

    def self.triggered_by?(message)
      message =~ /elo for *\w*/i
    end

    def self.help
      'elo for gamertag - fetch the elo from guardian.gg for a specific gamertag'
    end

    private
      def get_mode
        @mode, eloa, fora, gamertag = message.split(' ')
        @mode = 'trials'
        @mode = 'iron banner' if message.include?('iron banner')
        GG::MODES.keys.each { |gg_mode| @mode = gg_mode if message.include?(gg_mode) }
      end

      def get_gamertag
        mode, eloa, fora, @gamertag = message.split(' ')
        if mode == 'elo'
          eloa, fora, @gamertag = message.split(' ')
        end
        if message.include?('iron banner')
          eloa, fora, @gamertag = message.gsub('iron banner', '').split(' ')
        end
        if @gamertag =~ /<@\w{9}>/i
          @slack_user = client.web_client.users_info(user: @gamertag.gsub(/\W+/i, '').upcase).user
          @gamertag = Gamertag.parse(@slack_user.profile.title)
        end
      end

      def get_membership_ids
        if @gamertag
          @gg_user = GG::User.new(gamertag: @gamertag)
          @gg_user.get_membership_ids
          if @gg_user.membership_ids.empty?
            "Hi <@#{user}> I couldn’t find #{@gamertag} on guardian.gg."
          else
            get_elos
          end
        else
          title = @slack_user.profile.title.empty? ? 'empty' : "`#{@slack_user.profile.title}`"
          "Hi <@#{user}> I can't get a gamertag for #{@slack_user.name}. Her/His title on slack is #{title}. #{change_instructions}"
        end
      end

      def get_elos
        elos = []
        @gg_user.membership_ids.each do |mid|
          if @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[@mode] }.empty?
            elos << { platform: mid[:platform_id], elo: 'couldn’t find one' }
          else
            elo = @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[@mode] }.first['elo'].round
            elos << { platform: mid[:platform_id], elo: elo }
          end
        end
        if elos.length > 1
          elo_str = ""
          elos.each do |platform_elo|
            elo_str += " *#{platform_elo[:elo]}* (#{GG::PLATFORMS[platform_elo[:platform]]})"
          end
          "Hi <@#{user}> #{@gamertag}'s elo for #{@mode} is:#{elo_str}."
        else
          "Hi <@#{user}> #{@gamertag}'s elo for #{@mode} is: *#{elos.first[:elo]}*."
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
