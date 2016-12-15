module Response
  class Default < Base
    def initialize
      @dictionary = MarkovChain.new('lib/dictionaries/general.txt')
    end

    def text
      @dictionary.generate_sentences(1)
    end
  end
end
