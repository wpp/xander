module Response
  class MyElo < Base
    attr_reader :message, :user, :client, :mode

    def initialize(message, user, client)
      super()
      @message, @user, @client = message, user, client
      get_mode
      @slack_user = client.web_client.users_info(user: user).user
      @text = get_text
    end

    def self.triggered_by?(message)
      message =~ /^my *(\w|\s)* elo/i
    end

    def self.help
      '`@xander my gametype elo` - fetches your elo from guardian.gg, defaults to trials'
    end

    def get_text
      if slack_user_has_profile_title?
        get_gamertag
      else
        respond user, "I can't get your gamertag. Please add a profile title. #{change_instructions}"
      end
    rescue => e
      #puts "#{e.class.name} #{e.message}"
      TABLE
    end

    private
      def get_mode
        @mode = 'trials'
        GG::MODES.keys.each { |gg_mode| @mode = gg_mode if message.include?(gg_mode) }
      end

      def slack_user_has_profile_title?
        @slack_user.respond_to?(:profile) && @slack_user.profile.respond_to?(:title)
      end

      def get_gamertag
        @gamertag = Gamertag.parse(@slack_user.profile.title)
        if @gamertag
          get_membership_ids
        else
          title = @slack_user.profile.title.empty? ? 'empty' : "`#{@slack_user.profile.title}`"
          respond user, "I don't know your gamertag. Your profile title on slack is #{title}. #{change_instructions}"
        end
      end

      def get_membership_ids
        @gg_user = GG::User.new(gamertag: @gamertag)
        @gg_user.get_membership_ids

        if @gg_user.membership_ids.empty?
          respond user, "I couldn’t find you on guardian.gg. Make sure your gamertag is correct."
        else
          get_elos
        end
      end

      def get_elos
        elos = []
        @gg_user.membership_ids.each do |mid|
          if @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[mode] }.empty?
            elos << { platform: mid[:platform_id], elo: 'couldn’t find one' }
          else
            elo = @gg_user.get_elos(mid[:id]).select { |r| r['mode'] == GG::MODES[mode] }.first['elo'].round
            elos << { platform: mid[:platform_id], elo: elo }
          end
        end
        if elos.length > 1
          elo_str = ''
          elos.each do |platform_elo|
            elo_str += " *#{platform_elo[:elo]}* (#{GG::PLATFORMS[platform_elo[:platform]]})"
          end
          "Hi <@#{user}> your #{mode} elo is:#{elo_str}."
        else
          if elos.first[:elo] == 'couldn’t find one'
            "Hi <@#{user}> I couldn’t get a #{mode} elo for you on guardian.gg."
          else
            "Hi <@#{user}> your #{mode} elo is: *#{elos.first[:elo]}*."
          end
        end
      end

      def change_instructions
        if @client.respond_to?(:team) && @client.team.respond_to?(:domain)
          domain = @client.team.domain
        else
          domain = 'testing'
        end

        "Visit https://#{domain}.slack.com/account/profile, click 'Edit' and change it in the 'What I do section'. (`PSN: yourgamertag` or `XB1: yourgamertag`)"
      end
  end
end
