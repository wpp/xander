module Response
  class Daily < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/daily_challenge.txt")
      @text = @dictionary.generate_sentences(rand(1..3))
    end
  end
end
