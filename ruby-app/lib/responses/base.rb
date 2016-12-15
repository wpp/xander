module Response
  class Base
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
  end
end
