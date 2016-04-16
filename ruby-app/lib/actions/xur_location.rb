module Action
  class XurLocation
    # TODO extract, cleanup
    TABLE = '(╯°□°）╯︵ ┻━┻'

    def initialize
      @url = URI('http://www.destinylfg.com/findxur/')
    end

    def response
      scrape_xur_location
      "Xur's Location (#{@date}): #{@map}"
    rescue => e
      TABLE
    end

    private
      # TODO: get a second opinion?
      #doc = Nokogiri::HTML(open('http://whereisxur.com'))
      #img_link = doc.xpath('//*[@id="post-41"]/div/div/div[2]/div[1]/div/img').first.attributes['src'].value
      def scrape_xur_location
        doc = Nokogiri::HTML(open(@url))
        @date = doc.css(".col-xs-12>h2").first.children.first.text

        # first row with xurs inventory
        row = doc.css(".col-xs-12.col-sm-6>h2").first.parent.parent
        if row.css(".col-xs-12.col-sm-6>img").any?
          # for example: '/assets/findxur/xur-location-speaker-north.png'
          path = doc.css(".col-xs-12.col-sm-6>img").first.attributes['src'].value
          @map = "#{@url.scheme}://#{@url.host}#{path}"
        elsif row.css("p").any?
          @map = row.css("p").text
        else
          @map = "Couldn't find him"
        end
      end
  end
end
