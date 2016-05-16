module Response
  class Thx < Base
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/thx.txt")
    end

    def text
      @dictionary.generate_sentence
    end
  end
end
