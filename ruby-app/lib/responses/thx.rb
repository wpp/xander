module Response
  class Thx < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/thx.txt")
      @text = @dictionary.generate_sentence
    end

    def self.triggered_by?(message)
      message =~ /thanks?|thx/i
    end
  end
end
