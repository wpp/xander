module Response
  class Streamers
    # TODO who is currently online? twitch api
    def initialize
      @url = "https://usecanvas.com/imbriaco/low-sodium-streamers/4OuRsTOn8PithLvegHp3Df"
    end

    def text
      "Here are some pretty cool streamers: #{@url}"
    end
  end
end
