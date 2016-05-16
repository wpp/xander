module Response
  class Maps < Base
    # TODO extract, cleanup
    TABLE = '(╯°□°）╯︵ ┻━┻'

    def initialize
      @callout_url = 'http://mattaltepeter.com/destiny/maps/'
      @trials_url  = 'http://destinytracker.com/destiny/trials-of-osiris-history'
    end

    def text
      scrape_trials_map
      "Map is _#{@map}_ (#{@date}) #{@map_url}. Callouts are here: #{@callout_url}. Good luck!"
    rescue => e
      TABLE
    end

    private
      def scrape_trials_map
        Nokogiri::HTML(open(@trials_url)).css('table>tr')[1].children.each do |child|
          next if child.is_a?(Nokogiri::XML::Text) && child.text == "\n"

          if child.text =~ /\d{1,4}\/?/i
            @date = child.text
            next
          end

          if child.css('a').any?
            link = child.css('a').first
            @map_url = link.attributes['href'].value
            @map = link.children.first.text
            break
          elsif !child.text.empty? #was the case for random trials maps
            link = ''
            @map_url = ''
            @map = child.text.gsub("\n", '')
            break
          end
        end
      end
  end
end
