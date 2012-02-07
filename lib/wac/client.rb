#--
# Copyright (c) 2012-2012, RightScale.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++

require 'openssl'
require 'net/http/persistent'
require 'rufus-json/automatic'


module WrongApiClient

  def self.new(options)

    Client.new(options)
  end

  class Client

    ROOT = '/api/session'
    API_URI = 'https://my.rightscale.com'
    API_VERSION = '1.5'

    attr_reader :cookie
    attr_reader :session

    def initialize(options)

      @options = options
      @endpoint = options[:api_uri] || API_URI

      @http = Net::HTTP::Persistent.new('WrongApi')

      @cookie = login
      @session = new_resource(ROOT)
    end

    def to_s

      "#<#{self.class} #{@endpoint}>"
    end

    def new_resource(path)

      data = Rufus::Json.decode(request(:get, path).body)

      if data.is_a?(Array)
        data.collect { |d| ResourceStub.new(self, path, d) }
      else
        Resource.new(self, path, data)
      end
    end

    protected

    def login

      body = {
        'email' => @options[:email],
        'password' => @options[:password],
        'account_href' => "/api/accounts/#{@options[:account_id]}"
      }

      request(:post, ROOT, body)['set-cookie']
    end

    METHODS = {
      :get => Net::HTTP::Get,
      :post => Net::HTTP::Post,
      :delete => Net::HTTP::Delete
    }

    def request(method, path, body=nil)

      uri = URI.parse("#{@endpoint}#{path}")

      headers = {
        'X_API_VERSION' => API_VERSION,
        'Accept' => 'application/json'
      }
      headers['Cookie'] = @cookie if @cookie

      req = METHODS[method].new(uri.path, headers)
      req.set_form_data(body) if body

      @http.request(uri, req)
    end
  end

  class ResourceStub

    attr_reader :client, :path, :data

    def initialize(client, path, data)

      @client = client
      @path = data['links'].find { |l| l['rel'] == 'self' }['href']
      @data = data

      (@data['actions'] || []).each do |action|
        p "... action: #{action} !!"
      end

      (@data['links'] || []).each do |link|

        next if link['rel'] == 'self'

        define_instance_method(link['rel']) do
          client.new_resource(link['href'])
        end
      end
    end

    def to_s

      "#<#{self.class} #{@path}>"
    end

    protected

    def define_instance_method(meth, &block)

      (class << self; self; end).module_eval { define_method(meth, &block) }
    end
  end

  class Resource < ResourceStub

    def initialize(client, path, data)

      super
      @path = path
    end
  end
end

