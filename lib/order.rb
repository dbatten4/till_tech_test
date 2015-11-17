require 'json'

class Order

  TAX_RATE = 0.0864

  attr_reader :menu, :tax, :receipt, :net_total, :gross_total

  def initialize 
    @menu = JSON.parse(File.read('hipstercoffee.json')).first['prices'].first
    @receipt = Hash.new
    @gross_total = 0.0
    @tax = 0.0 
    @net_total = 0.0
  end

  def take_order(item, quantity)
    fail 'Not on menu' unless menu.key?(item)
    receipt_check_and_add(item, quantity)
    update_total(item, quantity)
  end

  def finalise_order
    calculate_net_total
    print_receipt
  end 

  private

  def print_receipt
    receipt.each do |item, quantity|
      puts "#{item} #{quantity} x #{menu[item]}"
    end
    puts ""
    puts "Gross total #{gross_total}"
    puts "Tax #{tax}"
    puts "Net total #{net_total}" 
  end

  def calculate_tax
    @tax = (@gross_total * TAX_RATE).round(2)
  end

  def update_total(item, quantity)
    @gross_total += (menu[item] * quantity)
  end

  def calculate_net_total
    calculate_tax
    @net_total = (@gross_total + @tax).round(2)
  end

  def receipt_check_and_add(item, quantity)
    receipt.key?(item) ? receipt[item] += quantity : receipt[item] = quantity
  end

end