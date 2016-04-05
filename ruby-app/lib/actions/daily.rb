module Action
  class Daily
    def initialize
      @dictionary = MarkovChain.new("lib/dictionaries/daily_challenge.txt")
    end

    def response
      @dictionary.generate_sentences(rand(1..3))
    end
  end
end
