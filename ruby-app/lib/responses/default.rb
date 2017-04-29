module Response
  class Default < Base
    def initialize
      super
      @text = Default.dictionary.generate_sentences(1)
    end

    def self.triggered_by?(message)
      false
    end

    def self.dictionary
      @@dictionary ||= MarkovChain.new('lib/dictionaries/general.txt')
    end
  end
end
