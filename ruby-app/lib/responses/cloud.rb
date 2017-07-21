module Response
  class Cloud < Base
    def initialize(*args)
      super()
      message = args[0]
      tmp = message.gsub(/cloud/i, message.include?('Cloud') ? 'Butt' : 'butt')
      @text = "_#{tmp}_"
    end

    def self.triggered_by?(message)
      message =~ /cloud/i
    end
  end
end
