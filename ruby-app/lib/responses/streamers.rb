module Response
  class Streamers < Base
    # TODO who is currently online? twitch api
    def initialize
      super()
      url = "https://usecanvas.com/imbriaco/low-sodium-streamers/4OuRsTOn8PithLvegHp3Df"
      @text = "Here are some pretty cool streamers: #{url}"
    end
  end
end
