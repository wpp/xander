module Action
  class GamertagElo
    attr_reader :message, :user

    def initialize(message, user)
      @message = message
      @user = user
      get_mode
      get_gamertag
    end

    def response
      get_membership_ids
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
      end

      def get_membership_ids
        @gg_user = GG::User.new(gamertag: @gamertag)
        @gg_user.get_membership_ids
        if @gg_user.membership_ids.empty?
          "Hi <@#{user}> I couldn’t find #{@gamertag} on guardian.gg."
        else
          get_elos
        end
      end

      def get_elos
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
          "Hi <@#{user}> #{@gamertag}'s elo for #{@mode} is:#{elo_str}."
        else
          "Hi <@#{user}> #{@gamertag}'s elo for #{@mode} is: *#{elos.first[:elo]}*."
        end
      end
  end
end
