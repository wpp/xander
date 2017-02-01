module Response
  class Morning < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/morning.txt")
      @text = @dictionary.generate_sentence
    end

    def self.triggered_by?(message)
      message =~ /(good\s)?morning?.*|yo slack-peeps/
    end
  end
end
