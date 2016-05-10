module Gamertag
  # Snowflakes, and I'm too lazy to improve these.
  TYPE_1 = /^((ps[4|n]|xb1|xboxone)(([:-]\W*)|\W*))+/i
  TYPE_2 = /\W*(warlock|titan|teacher)\W*ps[4|n]\W*\s?/i

  def self.parse(title)
    case title
    when /slacker/i
      'kurzinator'
    when /psn: palefacex . i'm on gmt/i
      'PalefaceX'
    when /software engineer at everlane; psn: esherido/i
      'Esherido'
    when /NeuronBasher, XB1: Neuron Basher. I also run a little startup called Operable./i
      'NeuronBasher'
    when /XB1: changelog PSN: superdealloc \(CET time\)/i
      'superdealloc'
    when /Software Engineer at Heroku; PSN\/XB1: daneharrigan/i
      'daneharrigan'
    when /PS4: RebelSenator. Titan main./i
      'RebelSenator'
    when /Dean of Students, Xbox One: KaiserHughes/i
      'KaiserHughes'
    when TYPE_1
      title.gsub(TYPE_1, '').chomp(' ')
    when TYPE_2
      title.gsub(TYPE_2, '').chomp(' ')
    else
      nil
    end
  end
end
