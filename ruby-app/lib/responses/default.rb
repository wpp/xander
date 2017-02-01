module Response
  class Default < Base
    def initialize
      super
      @dictionary = MarkovChain.new('lib/dictionaries/general.txt')
      @text = @dictionary.generate_sentences(1)
    end

    def self.triggered_by?(message)
      false
    end
  end
end
