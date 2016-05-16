module Response
  class Crucible < Base
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/crucible.txt")
    end

    def text
      @dictionary.generate_sentences(rand(1..2))
    end
  end
end
