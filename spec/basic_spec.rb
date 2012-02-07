
require 'spec_helper'


describe WrongApiClient do

  describe '.login' do

    it 'logs in' do

      r = WrongApiClient.login(CREDENTIALS)

      r.class.should == WrongApiClient::Resource
      r.path.should == '/api/session'
    end
  end

  describe '#to_s' do

    it 'does not reveal sensitive info' do

      s = WrongApiClient.login(CREDENTIALS)

      s.client.to_s.should_not match(/pass/)
      s.client.inspect.should_not match(/pass/)
    end
  end

  describe '#clouds' do

    it 'lists the available clouds' do

      s = WrongApiClient.login(CREDENTIALS)

      s.clouds.class.should == WrongApiClient::ResourceCollection
      s.clouds.map(&:class).uniq.should == [ WrongApiClient::ResourceStub ]
    end
  end

  describe WrongApiClient::ResourceStub do

    it 'responds to #show' do

      s = WrongApiClient.login(CREDENTIALS)

      s.clouds.first.respond_to?(:show).should == true
    end
  end

  describe WrongApiClient::Resource do

    it 'has fields' do

      s = WrongApiClient.login(CREDENTIALS)

      s.message.should ==
        'You have successfully logged into the RightScale API.'
    end

    it 'does not respond to #show' do

      s = WrongApiClient.login(CREDENTIALS)

      s.respond_to?(:show).should == false
    end
  end
end

