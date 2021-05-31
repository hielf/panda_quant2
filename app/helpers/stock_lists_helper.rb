require 'pycall/import'
include PyCall::Import
module StockListsHelper

  def get_all_stock_list
    pyimport 'easyquotation'
    quotation = easyquotation.use('sina')
    h = quotation.market_snapshot(prefix='True')
    h.each do |stock|
      begin
        new_stock = StockList.find_or_initialize_by(stock_code: stock[0][2..7])
        a = PinYin.of_string(stock[1]['name'], :ascii)
        py = ""
        a.map{|x| py = py + x[0].upcase}

        new_stock.stock_name = py
        new_stock.stock_display_name = stock[1]['name']
        new_stock.market_code = stock[0][0..1]
        new_stock.market = (stock[0][0..1] == "sz" ? "深A" : "沪A")

        new_stock.save!
        p new_stock
      rescue Exception => e
        Rails.logger.warn "get_all_stock_list error: #{e.message}"
        next
      end
    end
  end

end
