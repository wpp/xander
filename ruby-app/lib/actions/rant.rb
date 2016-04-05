module Action
  class Rant
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/daily_challenge.txt")
    end

    def response
      @dictionary.generate_sentences(rand(1..2)).downcase
    end
  end
end
