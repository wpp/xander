module Response
  class XurLocation < Base
    # TODO extract, cleanup
    TABLE = '(╯°□°）╯︵ ┻━┻'

    def initialize(user)
      @url = URI('http://www.destinylfg.com/findxur/')
      @user = user
    end

    def text
      scrape_xur_location
      "Hi <@#{@user}> you asked for Xur:"
    rescue => e
      TABLE
    end

    def attachments
      if uri?(@map)
        text = 'According to destinylfg Xur should be here:'
        image_url = @map
      else
        text = "According to destinylfg #{@map}"
        image_url = ''
      end

      [
        {
          "fallback" => "Xur's Location (#{@date}): #{@map}",
          "title" => "Xur's Location (#{@date})",
          "title_link" => "http://www.destinylfg.com/findxur/",
          "text" => text,
          "image_url" => image_url,
          "color" => "#CCA827"
        }
      ]
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

      # Thanks Simone Carletti
      # http://stackoverflow.com/a/5331096/980524
      def uri?(string)
        uri = URI.parse(string)
        %w( http https ).include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end
  end
end
