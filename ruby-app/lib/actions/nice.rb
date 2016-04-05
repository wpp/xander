module Action
  class Nice
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/nice.txt")
    end

    def response
      @dictionary.generate_sentence
    end
  end
end
