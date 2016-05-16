module Response
  class Nice
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/nice.txt")
    end

    def text
      @dictionary.generate_sentence
    end
  end
end
