module Response
  class Perk < Base
    def initialize(message, user, _client = nil)
      super()
      @message = message
      @user = user
      @message_query = @message.downcase.gsub(/perk/, '').lstrip
    end

    def self.triggered_by?(message)
      message =~ /perk/i
    end

    def text
      "Hi <@#{@user}> here is what I found for: *#{@message_query}*"
    end

    def attachments
      [
        {
          'fallback' => "Perk description for #{@message_query}",
          'fields' => fields(lookup),
          'color' => '#FFCE1F'
        }
      ]
    end

    private

    def fields(db_results)
      db_results.map do |item|
        {
          'title' => item['displayName'],
          'value' => item['displayDescription']
        }
      end
    end

    # for some reason some perks are duplicated
    def lookup
      json = []
      db = SQLite3::Database.open(
        './db/world_sql_content_3393e6968b07cafc465169cf543d1bb6.content'
      )
      results = db.execute(query)
      results.each do |r|
        parsed = JSON.parse(r[1])
        if json.select { |j| j['displayName'] == parsed['displayName'] }.empty?
          json << parsed
        end
      end
      json
    end

    def query
      'SELECT * FROM DestinySandboxPerkDefinition ' \
      "WHERE json LIKE '%#{@message_query}%' LIMIT 10"
    end
  end
end
