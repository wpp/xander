module Action
  class Morning
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/morning.txt")
    end

    def response
      @dictionary.generate_sentence
    end
  end
end
