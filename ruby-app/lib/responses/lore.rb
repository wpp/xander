module Response
  class Lore < Base
    def initialize(message, user)
      @message = message
      @user = user
      @db = SQLite3::Database.open('./test/world_sql_content_3393e6968b07cafc465169cf543d1bb6.content')
    end

    def text
      result = query
      json = JSON.parse(result[0][1])
      "Hi <@#{@user}> here is your result: *#{json['cardName']}*\n _#{json['cardDescription']}_"
    end


    private
      def query
        message_query = @message.split(' ')[-1]
        statement = "SELECT * FROM DestinyGrimoireCardDefinition where json like '%#{message_query}%' LIMIT 1"
        result = @db.execute(statement)
      end
  end
end
