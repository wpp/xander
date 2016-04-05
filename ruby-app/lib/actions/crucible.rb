module Action
  class Crucible
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/crucible.txt")
    end

    def response
      @dictionary.generate_sentences(rand(1..2))
    end
  end
end
