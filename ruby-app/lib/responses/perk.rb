module Response
  class Perk < Base
    def initialize(message, user)
      super()
      @message = message
      @user = user
      @db = SQLite3::Database.open('./db/world_sql_content_3393e6968b07cafc465169cf543d1bb6.content')
      @message_query = @message.downcase.gsub(/perk/, '').lstrip
      @text = get_text
    end

    def self.triggered_by?(message)
      message =~ /perk/i
    end

    def get_text
      @json = []
      result = query
      result.each do |r|
        parsed = JSON.parse(r[1])
        # for some reason some perks are duplicated
        if @json.select { |j| j['displayName'] == parsed['displayName'] }.empty?
          @json << parsed
        end
      end
      "Hi <@#{@user}> here is what I found for: *#{@message_query}*"
    end

    def attachments
      fields = []

      @json.each do |item|
        fields << {
          'title' => item['displayName'],
          'value' => item['displayDescription']
        }
      end

      [
        {
          "fallback" => "Perk description for #{@message_query}",
          "fields" => fields,
          "color" => "#FFCE1F"
        }
      ]
    end

    private
      def query
        statement = "SELECT * FROM DestinySandboxPerkDefinition where json like '%#{@message_query}%' LIMIT 10"
        result = @db.execute(statement)
      end
  end
end
