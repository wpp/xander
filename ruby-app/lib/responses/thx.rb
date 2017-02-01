module Response
  class Thx < Base
    def initialize
      super()
      @text = MarkovChain.new('lib/dictionaries/thx.txt').generate_sentence
    end

    def self.triggered_by?(message)
      message =~ /thanks?|thx/i
    end
  end
end
