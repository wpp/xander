module Response
  class Table < Base
    def initialize
      super()
      @text = '┬─┬ノ( º _ ºノ)'
    end

    def self.triggered_by?(message)
      message =~ /┸━┸|┻━┻/i
    end
  end
end
