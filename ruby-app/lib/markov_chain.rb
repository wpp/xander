require 'json'
require 'byebug'
require 'erb'

class MarkovChain
  attr_reader :name, :dictionary, :words_per_sentence

  def initialize(name)
    @name = name
    if File.exists?(@name)
      @dictionary = File.read(@name)
    else
      raise ArgumentError, "#{@name} does not exist"
    end

    sentences = @dictionary.split(/[.!?]+/)
    @words_per_sentence = []

    sentences.each do |sentence|
      words = sentence.split(' ')
      @words_per_sentence << words.count
    end

    @table = {}
    build_frq_table unless @dictionary.empty?
  end

  def parse(text)
    text.gsub(/[()]/, '').split(' ')
  end

  def build_frq_table
    words = parse(@dictionary)
    words.each_index do |i|
      prefix = [words[i], words[i+1]].compact
      suffix = [words[i+2]].compact
      @table[prefix] = @table[prefix] ? (@table[prefix] + suffix) : suffix # we don't count, we just add again
    end
  end

  def generate_sentence
    sentence = []
    tries = 0 # kind of a handbrake, in case we can't find a good start prefix or sentence gets too long
    w1, w2, w3 = ''

    until w1[0] =~ /[A-Z]/ || tries > 20
      w1, w2 = @table.keys[rand(0..@table.keys.length-1)]
      tries += 1
    end
    w1[0] = w1[0].upcase

    sentence << w1
    sentence << w2

    # TODO attempt to get more accurate sentence lengths?
    # minlength = @words_per_sentence[rand(0..@words_per_sentence.length-1)]

    tries = 0
    until (w3 =~ /\w+[.!?]+/i) || @table[[w1,w2]].nil? || @table[[w1,w2]].empty? || tries > 30
      # randomly choose w3, one of the successors of prefix w1, w2
      w3 = @table[[w1,w2]][rand(0..@table[[w1,w2]].length-1)]
      #sentence[-1] += '.' if w3[0] =~ /[A-Z]/
      sentence << w3
      w1 = w2
      w2 = w3
      tries += 1
    end
    # TODO if it ends on coma don't count try?
    # TODO random line end char?
    sentence.compact!
    sentence[-1] += '.' unless sentence.last[-1] =~ /[.!?,]+/
    sentence.join(' ')
  end

  def generate_sentences(num_sentences=3)
    sentences = []
    num_sentences.times { sentences << generate_sentence }
    sentences.join(' ')
  end
end
