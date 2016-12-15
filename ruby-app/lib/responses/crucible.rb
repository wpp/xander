module Response
  class Crucible < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/crucible.txt")
      @text = @dictionary.generate_sentences(rand(1..2))
    end
  end
end
