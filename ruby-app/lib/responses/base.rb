module Response
  class Base
    def text
      'default response'
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
