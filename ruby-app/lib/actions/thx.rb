module Action
  class Thx
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/thx.txt")
    end

    def response
      @dictionary.generate_sentence
    end
  end
end
