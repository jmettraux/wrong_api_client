
require 'spec_helper'


describe WrongApiClient do

  describe '.new' do

    it 'logs in' do

      r = WrongApiClient.new(CREDENTIALS)

      #r.class.should == WrongApiClient::Resource
      r.cookie.should_not == nil
    end
  end

  describe '#to_s' do

    it 'does not reveal sensitive info' do

      c = WrongApiClient.new(CREDENTIALS)

      c.to_s.should_not match(/pass/)
      c.inspect.should_not match(/pass/)
    end
  end
end

