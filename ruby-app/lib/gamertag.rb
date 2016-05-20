require 'strscan'

module Gamertag
  def self.parse(title)
    case title
    when /slacker/i
      'kurzinator'
    when /NeuronBasher, XB1: Neuron Basher. I also run a little startup called Operable./i
      'NeuronBasher'
    when /XB1: changelog PSN: superdealloc \(CET time\)/i
      'superdealloc'
    when /Software Engineer at Heroku; PSN\/XB1: daneharrigan/i
      'daneharrigan'
    when /OwlBoy - Warlock \| PS4/i
      'OwlBoy'
    else
      parsers = [PlayStationParser, XboxParser]
      parsers.each do |parser_class|
        parser = parser_class.new(title)
        result = parser.extract_gamertag()

        return result unless result.nil?
      end

      return nil
    end
  end

  class GamertagParser
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def extract_gamertag
      return if self.text.nil?

      scanner = StringScanner.new(self.text)
      skipped_characters = scanner.skip_until(beginning_regex())
      return if skipped_characters.nil?

      return scanner.scan_until(ending_regex()).strip().chomp('.')
    end

    protected

    def beginning_regex
      raise "beginning_regex not implemented"
    end

    def ending_regex
      raise "ending_regex not implemented"
    end
  end

  class PlayStationParser < GamertagParser
    def beginning_regex
      /PS[4|N]:?\s*-?\s*/i
    end

    def ending_regex
      /\.|\s|$/
    end
  end

  class XboxParser < GamertagParser
    def beginning_regex
      /(XB1|Xbox[\s]+One|xboxone):?\s*/i
    end

    def ending_regex
      /\.|$/
    end
  end
end
