module Response
  class Help < Base
    def initialize(*)
      super()
    end

    def self.triggered_by?(message)
      message =~ /he?lp( me)?|hilfe|man|(list ?)?commands/i
    end

    def text
      'Here is how I could help you out:'
    end

    def attachments
      text_part = Response.all.select { |r| r.respond_to?(:help) }
                  .map(&:help)
                  .join("\n")
      [
        {
            "fallback"  => "Help",
            "text"      => text_part.chomp("\n"),
            "color"     => '#97322D',
            "mrkdwn_in" => [
                "text","pretext"
            ]
        }
      ]
    end
  end
end
