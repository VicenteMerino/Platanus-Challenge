# frozen_string_literal: true

require 'nokogiri'
require_relative './transactions'

transactions = Transactions.new
maximum_trades = transactions.all_markets_maximum_trade

builder = Nokogiri::HTML::Builder.new do |doc|
  doc.html do
    doc.head do
      doc.link(rel: 'stylesheet', href: 'table.css')
    end
    doc.body do
      doc.table do
        doc.tr do
          doc.th { doc.text 'Market' }
          doc.th { doc.text 'Timestamp' }
          doc.th { doc.text 'Amount' }
          doc.th { doc.text 'Price' }
          doc.th { doc.text 'Transaction type' }
          doc.th { doc.text 'Address' }
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

puts builder.to_html
