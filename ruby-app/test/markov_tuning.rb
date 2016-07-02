require_relative '../lib/markov_chain'
require 'erb'

erb = ERB.new(File.read("test.html.erb"))
File.open('result.html', 'w') do |f|
  Dir['../lib/dictionaries/*'].each do |dictionary|
    puts "#{dictionary}"
    @markov_chain = MarkovChain.new(dictionary)
    f.write(erb.result binding)
  end
end
