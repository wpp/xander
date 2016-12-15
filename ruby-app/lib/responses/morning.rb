module Response
  class Morning < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/morning.txt")
      @text = @dictionary.generate_sentence
    end
  end
end
