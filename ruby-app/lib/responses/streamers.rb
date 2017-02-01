module Response
  class Streamers < Base
    # TODO who is currently online? twitch api
    def initialize(message, user, client)
      super()
      url = "https://usecanvas.com/imbriaco/low-sodium-streamers/4OuRsTOn8PithLvegHp3Df"
      @text = "Here are some pretty cool streamers: #{url}"
    end

    def self.triggered_by?(message)
      message =~ /streamers|stream|twitch|twitch.tv/i
    end
  end
end
