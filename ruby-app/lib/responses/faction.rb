module Response
  class Faction < Base
    def initialize(message, user=nil, client=nil)
      super()
      @text = 'My allegiance is with Dead Orbit. All hail Severus Snape. :metal:'
    end

    def self.triggered_by?(message)
      message =~ /faction/i
    end
  end
end
