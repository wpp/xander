module Response
  class Cloud < Base
    def initialize(message)
      super()
      @text = message.gsub(/cloud/i, "butt")
    end

    def self.triggered_by?(message)
      message =~ /cloud/i
    end
  end
end
