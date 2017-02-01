module Response
  # Base response, couple of things every response needs.
  class Base
    TABLE = '(╯°□°）╯︵ ┻━┻'.freeze

    attr_reader :text

    def initialize
      @text = 'default response'
    end

    def respond(username, message)
      greeting = Greeting.greet username
      "#{greeting} #{message}"
    end

    def attachments
      []
    end

    def self.triggered_by?(message)
      unless self.name == "Response::Base"
        puts "#{__method__} is not implemented in #{self.name}"
      end

      false
    end
  end
end
