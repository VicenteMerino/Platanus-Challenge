# frozen_string_literal: true

# transaction model to retrieve the required information
class Transactions
  def initialize(api_handler)
    @api_handler = api_handler
  end

  def markets_maximum_trades
    markets = markets_names
    maximum_trades = []
    markets.each do |market|
      maximum_trades << maximum_trade(market)
    end
    maximum_trades
  end

  private

  def markets_names
    @api_handler.markets['markets'].map { |market| market.slice('id')['id'] }
  end

  def yesterday_timestamp
    (Time.now.to_f * 1000).to_i - 60 * 60 * 24 * 1000
  end

  def last_day_trades(market_id)
    first_trades = @api_handler.trades(market_id)['trades']
    limit_timestamp = yesterday_timestamp
    trades = filtered_trades(first_trades, limit_timestamp)
    last_timestamp = first_trades['last_timestamp'].to_i
    while limit_timestamp < last_timestamp
      next_trades = @api_handler.trades(market_id, limit_timestamp)['trades']
      trades += filtered_trades(next_trades, limit_timestamp)
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
    max_trade = trades.max_by { |trade| trade[1].to_f * trade[2].to_f }
    [market_id] + max_trade.slice(0, max_trade.length - 1)
  end
end
