module Action
  class Rant
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/rant.txt")
    end

    def response
      @dictionary.generate_sentences(rand(1..2)).downcase
    end
  end
end
