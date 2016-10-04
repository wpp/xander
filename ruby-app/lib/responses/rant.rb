module Response
  class Rant < Base
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/rant.txt")
    end

    def text
      @dictionary.generate_sentences(rand(1..2)).upcase
    end
  end
end
