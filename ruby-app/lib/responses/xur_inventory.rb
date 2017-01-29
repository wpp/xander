module Response
  class XurInventory < Base

    def initialize(user)
      super()
      @api_key = ENV['BUNGIE_API_TOKEN'] || File.read('.bungie_token').chomp
      @user = user
      @xur_gone = true
      @text = get_text
    end

    def get_text
      case get_xur_inventory
      when 5
        "Hi <@#{@user}> bungie's API is down for maintenance. Sorry."
      when 1627
        "Hi <@#{@user}> Xur hasn't arrived yet."
      else
        "Hi <@#{@user}> you asked for Xur's inventory:"
      end
    end

    def attachments
      return [] if @xur_gone

      fields = []
      @inventory.each do |item|
        fields << {
          'title' => item['itemName'],
          'value' => "<https://www.bungie.net/en/armory/Detail?item=#{item['itemHash']}|View in armory>",
          'short' => true
        }
      end

      [
        {
          'fallback' => "Xur's Inventory: #{@inventory.map {|i| i['itemName']}.join(', ')}",
          'text' => "Xur's Inventory",
          'thumb_url' => 'https://pbs.twimg.com/profile_images/525558766180118528/hyDrezNf_400x400.png',
          'fields' => fields,
          'color' => '#FFCE1F'
        }
      ]
    end

    private
      def get(uri)
        uri = URI(uri)
        req = Net::HTTP::Get.new(uri)
        req['X-API-Key'] = @api_key
        response = Net::HTTP.start(uri.hostname, use_ssl: true) {|http|
          http.request(req)
        }
        JSON.parse(response.body)
      rescue JSON::ParserError
        []
      end

      def get_xur_inventory
        @inventory = []

        response = get('https://www.bungie.net/Platform/Destiny/Advisors/Xur/')

        if response['ErrorStatus'] != 'Success'
          return response['ErrorCode']
        else
          @xur_gone = false
        end

        nr = Time.parse(response['Response']['data']['nextRefreshDate'])
        cache_name = "cache/#{nr}.json"
        if File.exists?(cache_name)
          @inventory = JSON.parse(File.read(cache_name))
        else
          sale_items = response['Response']['data']['saleItemCategories']
                        .map { |sic| sic['saleItems'] }
                        .flatten
                        .map { |s| s['item']['itemHash'] }

          sale_items.each do |si|
            item = get("https://www.bungie.net/Platform/Destiny/Manifest/6/#{si}/")
            @inventory << item['Response']['data']['inventoryItem']
          end
          File.open(cache_name, 'w') do |f|
            f.write(@inventory.to_json)
          end
        end
      end
  end
end
