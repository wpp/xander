module Response
  class Thx < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/thx.txt")
      @text = @dictionary.generate_sentence
    end
  end
end
