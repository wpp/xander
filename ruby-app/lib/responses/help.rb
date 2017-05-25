module Response
  class Help < Base
    def initialize(*)
      super()
    end

    def self.triggered_by?(message)
      message =~ /he?lp( me)?|hilfe|man|(list ?)?commands/i
    end

    def text
      Response.all.select { |r| r.respond_to?(:help) }.map(&:help)
    end
  end
end
