
require 'spec_helper'


describe WrongApiClient do

  describe '.new' do

    it 'instantiates' do

      c = WrongApiClient.new(CREDENTIALS)

      c.class.should == WrongApiClient::Client
    end
  end

  describe '#to_s' do

    it 'does not reveal sensitive info' do

      c = WrongApiClient.new(CREDENTIALS)

      c.to_s.should_not match(/pass/)
    end
  end
end

