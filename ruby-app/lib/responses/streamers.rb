module Response
  class Streamers < Base
    # TODO who is currently online? twitch api
    def initialize(message, user=nil, client=nil)
      super()
      url = "https://usecanvas.com/imbriaco/low-sodium-streamers/4OuRsTOn8PithLvegHp3Df"
      @text = "Here are some pretty cool streamers: #{url}"
    end

    def self.triggered_by?(message)
      message =~ /streamers|stream|twitch|twitch.tv/i
    end

    def self.help
      '`@xander streamers` - returns a list of streamers we like'
    end
  end
end
