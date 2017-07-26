module Response
  class Daily < Base
    def initialize(*)
      super()
      @dictionary = MarkovChain.new('lib/dictionaries/daily_challenge.txt')
      @text = @dictionary.generate_sentences(rand(1..3))
    end

    def self.triggered_by?(message)
      message =~ /daily/i
    end

    def self.help
      '`@xander daily` - suggest a topic for the #dailychallenge'
    end
  end
end
