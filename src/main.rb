# frozen_string_literal: true

require 'nokogiri'
require_relative 'api_handler'
require_relative 'transactions'

api_handler = ApiHandler.new
transactions = Transactions.new(api_handler)
maximum_trades = transactions.markets_maximum_trades

builder = Nokogiri::HTML::Builder.new do |doc|
  doc.html do
    doc.head do
      doc.link(rel: 'stylesheet', href: 'assets/table.css')
    end
    doc.body do
      doc.table do
        doc.tr do
          doc.th { doc.text 'Market' }
          doc.th { doc.text 'Timestamp' }
          doc.th { doc.text 'Amount' }
          doc.th { doc.text 'Price' }
          doc.th { doc.text 'Transaction type' }
        end
        maximum_trades.each do |trade|
          doc.tr do
            trade.each do |value|
              doc.td { doc.text value.to_s }
            end
          end
        end
      end
    end
  end
end

html_file = File.new('table.html', 'w')
html_file.puts builder.to_html
html_file.close
