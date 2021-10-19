# frozen_string_literal: true

require 'json'
require_relative 'api_handler'

# transaction model to retrieve the required information
class Transactions
  def initialize
    @api_handler = ApiHandler.new
  end

  def markets_names
    @api_handler.markets['markets'].map { |market| market.slice('id')['id'] }
  end

  def current_timestamp
    (Time.now.to_f * 1000).to_i - 60 * 60 * 24 * 1000
  end

  def last_day_trades(market_id)
    first_trades = @api_handler.trades(market_id)['trades']
    timestamp = current_timestamp
    trades = filtered_trades(first_trades, timestamp)
    last_timestamp = first_trades['last_timestamp'].to_i
    while timestamp < last_timestamp
      next_trades = @api_handler.trades(market_id, timestamp)['trades']
      trades += filtered_trades(next_trades, timestamp)
      last_timestamp = next_trades['last_timestamp'].to_i
    end
    trades
  end

  def filtered_trades(trades, timestamp)
    filtered_entries = []
    trades['entries'].each do |entry|
      entry_timestamp = entry[0].to_i
      filtered_entries << entry if entry_timestamp >= timestamp
    end
    filtered_entries
  end

  def maximum_trade(market_id)
    trades = last_day_trades(market_id)
    [market_id] + trades.max_by { |trade| trade[1].to_f * trade[2].to_f }
  end

  def all_markets_maximum_trade
    markets = markets_names
    maximum_trades = []
    markets.each do |market|
      maximum_trades << maximum_trade(market)
    end
    maximum_trades
  end
end

transactions = Transactions.new
transactions.all_markets_maximum_trade.each do |market|
  puts market.to_s
end
