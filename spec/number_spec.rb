require 'spec_helper'

require_relative '../lib/ally/detector/number'

describe Ally::Detector::Number do

  context 'detect a number' do
    it 'by itself' do
      subject.inquiry('0').detect.should == [0]
    end

    it 'a single word' do
      subject.inquiry('zero!')
        .detect.should == [0]
    end

    it 'in mid-sentence' do
      subject.inquiry('There are 50 states.')
        .detect.should == [50]
    end

    it 'with puncuation' do
      subject.inquiry('The world is turning 100% of the time')
        .detect.should == [100]
    end

    it 'a very long sentence with a very long number' do
      subject.inquiry('An example of a really big number is seven hundred and fifty two billion, four hundred and twenty million, sixty thousand and forty two')
        .detect.should == [752_420_060_042]
    end

    it 'when multiple numbers exists' do
      subject.inquiry('i have ten fingers and 2 feet')
        .detect.should == [10, 2]
    end

    it 'when no numbers exists' do
      subject.inquiry('nothing to see here')
        .detect.should.nil?
    end
  end
end
