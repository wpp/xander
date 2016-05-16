module Response
  class Default < Base
    def initialize
      @defaults = File.read('lib/dictionaries/defaults.txt').split("\n")
    end

    def text
      @defaults[rand(0..@defaults.length - 1)]
    end
  end
end
