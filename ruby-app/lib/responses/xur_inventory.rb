module Response
  class XurInventory < Base
    # TODO extract, cleanup
    TABLE = '(╯°□°）╯︵ ┻━┻'

    def initialize(user)
      @url = URI('http://www.destinylfg.com/findxur/')
      @user = user
    end

    def text
      scrape_xur_inventory
      "Hi <@#{@user}> you asked for Xur's inventory:"
    rescue => e
      TABLE
    end

    def attachments
      fields = []
      @inventory.each do |item|
        fields << {
          'title' => item[:text],
          'value' => "<#{item[:link]}|Inspect>",
          'short' => true
        }
      end
      [
        {
          'fallback' => 'Xur\'s Inventory: http://www.destinylfg.com/findxur/',
          'text' => "<http://www.destinylfg.com/findxur/|Xur's Inventory> (#{@date})",
          'thumb_url' => 'https://pbs.twimg.com/profile_images/525558766180118528/hyDrezNf_400x400.png',
          'fields' => fields,
          'color' => '#FFCE1F'
        }
      ]
    end

    private
      def scrape_xur_inventory
        doc = Nokogiri::HTML(open(@url))

        @date = doc.css(".col-xs-12>h2").first.children.first.text
        @inventory = []
        doc.css(".list-unstyled").first.children.each do |c|
          if c.name == 'li'
            link = c.children.first.attributes['href']
            text = c.children.first.children.text

            @inventory << { text: text, link: link }
          end
        end
      end
  end
end
