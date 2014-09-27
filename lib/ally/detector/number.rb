require 'ally/detector'
require 'ally/detector/number/version'

module Ally
  module Detector
    class Number
      include Ally::Detector

      require 'numerouno'

      def initialize(inquiry = nil)
        super # do not delete
        @number_words = %w(
          zero none one two three four five six seven eight nine ten eleven twelve
          thirteen fourteen fifteen sixteen seventeen eighteen nineteen
          twenty thirty forty fifty sixty seventy eighty ninety hundred
          thousand million billion trillion quintillion sextillion
          septillion octillion nonillion decillion undecillion duodecillion
          tredecillion quattuordecillion quindecillion sexdecillion
          septendecillion octodecillion novemdecillion vigintillion centillion
          and
        )
      end

      def detect
        @datapoints = []
        word_sets = []
        set = []
        is_set = false
        @inquiry.words_chomp_punc.each_with_index do |word|
          # in case words are hyphenated
          word_split = word.split('-')
          word_split.each do |w|
            if @number_words.include?(w.downcase)
              w = w.downcase
              # need to make sure the word 'and' isn't the start of
              # of a new set
              set << w unless w == 'and' && is_set == false
              is_set = true
            elsif word =~ /^[0-9]+$/
              is_set = true
              set << w
            else
              word_sets << set.join(' ') if set.length > 0
              set = []
              is_set = false
            end
          end
        end
        word_sets << set.join(' ') if is_set == true
        word_sets.each do |x|
          begin
            @datapoints << Numerouno.parse(x)
          rescue
          end
        end
        if @datapoints.length == 0
          nil
        else
          @data_detected = true
          @datapoints
        end
      end
    end
  end
end
