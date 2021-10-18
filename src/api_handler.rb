# frozen_string_literal: true

require 'rest-client'
require 'json'

# api handler  for the required api queries
class ApiHandler
  def initialize
    @base_url = 'https://www.buda.com/api/v2'
  end

  def markets
    url = "#{@base_url}/markets"
    response = RestClient.get(url)
    JSON.parse(response.body)
  end

  def trades(market_id, timestamp: nil)
    url = if timestamp
            "#{@base_url}/markets/#{market_id}/trades?timestamp=#{timestamp}?limit=100"
          else
            "#{@base_url}/markets/#{market_id}/trades?limit=100"
          end
    response = RestClient.get(url)
    JSON.parse(response.body)
  end
end
