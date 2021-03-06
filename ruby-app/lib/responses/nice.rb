module Response
  class Nice < Base
    def initialize(*)
      super()
      @dictionary = MarkovChain.new('lib/dictionaries/nice.txt')
      @text = @dictionary.generate_sentence
    end

    def self.triggered_by?(message)
      message =~ /apologi(s|z)e|behave|nice|sorry|sry/i
    end
  end
end
