module Response
  class Rant < Base
    def initialize
      super()
      @dictionary = MarkovChain.new("lib/dictionaries/rant.txt")
      @text = @dictionary.generate_sentences(rand(1..2)).upcase
    end

    def self.triggered_by?(message)
      message =~ /rant|problem|fault|blame|salt/i
    end
  end
end
