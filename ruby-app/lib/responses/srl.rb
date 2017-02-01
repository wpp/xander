module Response
  class Srl < Base
    def initialize(message, user, client)
      super()
      @text = "I'm not gonna talk about SRL."
    end

    def self.triggered_by?(message)
      message =~ /srl|rac[e|ing]/i
    end
  end
end
