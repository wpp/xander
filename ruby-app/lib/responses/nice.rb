module Response
  class Nice < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/nice.txt")
      @text = @dictionary.generate_sentence
    end
  end
end
