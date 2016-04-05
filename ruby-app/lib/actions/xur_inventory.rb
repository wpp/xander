module Action
  class XurInventory
    # TODO extract, cleanup
    TABLE = '(╯°□°）╯︵ ┻━┻'

    def initialize
      @url = URI('http://www.destinylfg.com/findxur/')
    end

    def response
      scrape_xur_inventory
      "Xur's Inventory (#{@date}):\n#{@inventory.join("\n")}"
    rescue => e
      TABLE
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

            @inventory << "_#{text}_: #{link}"
          end
        end
      end
  end
end
