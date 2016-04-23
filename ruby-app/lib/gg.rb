module GG
  # Endpoints
  API   = 'http://api.guardian.gg'
  PROXY = 'http://proxy.guardian.gg'

  # Platforms
  XBOX = 1
  PSN  = 2

  PLATFORMS = {
    1 => 'XBOX',
    2 => 'PSN'
  }

  MODES = {
    'skirmish'    => 9,
    'control'     => 10,
    'salvage'     => 11,
    'clash'       => 12,
    'rumble'      => 13,
    'trials'      => 14,
    'doubles'     => 15,
    'iron banner' => 19,
    'elimination' => 23,
    'rift'        => 24
  }

  class User
    attr_reader :user, :membership_ids

    def initialize(gamertag: 'wpp31')
      @gamertag = gamertag
    end

    def get_user_for(platform)
      uri = URI(URI.encode("#{PROXY}/Platform/Destiny/SearchDestinyPlayer/#{platform}/#{@gamertag}/"))
      response = Net::HTTP.get_response(uri)
      body = JSON.parse(response.body)['Response']
      body.empty? ? {} : body[0]
    rescue JSON::ParserError
      []
    end

    def get_membership_ids
      @membership_ids = []

      unless (psn_user  = get_user_for(PSN)).empty?
        @membership_ids << { id: psn_user['membershipId'], platform_id: PSN }
      end

      unless (xbox_user = get_user_for(XBOX)).empty?
        @membership_ids << { id: xbox_user['membershipId'], platform_id: XBOX }
      end
    end

    def get_elos(membership_id)
      uri = URI(URI.encode("#{API}/elo/#{membership_id}"))
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body)
    end
  end
end
