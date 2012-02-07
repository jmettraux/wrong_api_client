
require 'spec_helper'


describe WrongApiClient do

  before(:each) do
    @session = WrongApiClient.login(CREDENTIALS)
  end

  context 'errors' do

    it 'raises WrongApiClient::Error instances' do

      begin
        WrongApiClient.login({ 'nada' => 'nada' })
      rescue => e
      end

      e.class.should ==
        WrongApiClient::Error
      e.message.should ==
        "400: ParameterError: Parameter 'account_href' is invalid"
      e.http_code.should ==
        400
    end
  end

  describe '.login' do

    it 'logs in' do

      r = WrongApiClient.login(CREDENTIALS)

      r.class.should == WrongApiClient::Resource
      r.path.should == '/api/session'
    end
  end

  describe 'the session' do

    describe '#clouds' do

      it 'lists the available clouds' do

        @session.clouds.class.should ==
          WrongApiClient::ResourceCollection
        @session.clouds.map(&:class).uniq.should ==
          [ WrongApiClient::ResourceStub ]
      end
    end
  end

  describe WrongApiClient::Client do

    describe '#to_s' do

      it 'does not reveal sensitive info' do

        @session.client.to_s.should_not match(/pass/)
        @session.client.inspect.should_not match(/pass/)
      end
    end
  end

  describe WrongApiClient::ResourceStub do

    it 'responds to #show' do

      @session.clouds.first.respond_to?(:show).should == true
    end

    describe '#show' do

      it 'returns the Resource instance' do

        r = @session.clouds.first.show

        r.class.should == WrongApiClient::Resource
      end
    end
  end

  describe WrongApiClient::Resource do

    it 'has fields' do

      @session.message.should ==
        'You have successfully logged into the RightScale API.'
    end

    it 'lists actions and links' do

      @session.actions.should == []
      @session.links.map { |l| l['rel'] }.should include('self')
    end

    it 'does not respond to #show' do

      @session.respond_to?(:show).should == false
    end
  end
end

