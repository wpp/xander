module Response
  class Nice < Base
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/nice.txt")
    end

    def text
      @dictionary.generate_sentence
    end
  end
end
