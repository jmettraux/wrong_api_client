
require 'spec_helper'


describe WrongApiClient do

  describe '.new' do

    it 'logs in' do

      r = WrongApiClient.new(CREDENTIALS)

      r.cookie.should_not == nil
      r.session.class.should == WrongApiClient::Resource
    end
  end

  describe '#to_s' do

    it 'does not reveal sensitive info' do

      c = WrongApiClient.new(CREDENTIALS)

      c.to_s.should_not match(/pass/)
      c.inspect.should_not match(/pass/)
    end
  end

  describe '#clouds' do

    it 'lists the available clouds' do

      c = WrongApiClient.new(CREDENTIALS)

      c.session.clouds.class.should ==
        Array
      c.session.clouds.collect { |e| e.class }.uniq.should ==
        [ WrongApiClient::ResourceStub ]
    end
  end
end

