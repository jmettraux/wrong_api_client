
# wrong_api_client

A lean RightAPI client. Uses net-http-persistent.

This is not production-ready!


## usage

    require 'rubygems'
    require 'pp'
    require 'wrong_api_client'

    client = WrongApiClient.login(
      :account_id => '71',
      :email => 'xxx@rightscale.com',
      :password => 'yyy')

    pp client.links
    pp client.clouds.index


## license

MIT

