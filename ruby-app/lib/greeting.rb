class Greeting
  GREETINGS = ["Hey", "Hi", "Howdy", "Hello"]

  def self.greet(username)
    greeting = GREETINGS.sample
    "#{greeting} #{username}!" unless username.nil?
  end
end
