module Action
  class Default
    def initialize
      @defaults = File.read('lib/dictionaries/defaults.txt').split("\n")
    end

    def response
      @defaults[rand(0..@defaults.length - 1)]
    end
  end
end
