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
    @finalised = false
  end

  def take_order(item, quantity)
    fail 'Not on menu' unless menu.key?(item)
    receipt_check_and_add(item, quantity)
    update_total(item, quantity)
  end

  def finalise_order
    discount_check
    calculate_net_total
    print_receipt
    @finalised = true
  end 

  def take_payment(amount)
    order_and_payment_check(amount)
    (amount - @net_total).round(2)
  end

  private

  def discount_check 
    @gross_total = @gross_total * 0.95 if @gross_total > 50
  end

  def print_receipt
    receipt.each do |item, quantity|
      puts "#{item} #{quantity} x #{menu[item]}"
    end
    puts ""
    puts "Gross total #{gross_total}"
    puts "Tax #{tax}"
    puts "Net total #{net_total}" 
  end

  def order_and_payment_check(amount)
    fail 'Order has not been finalised' unless @finalised
    fail 'Insufficient payment' if amount < @net_total
  end

  def calculate_tax
    @tax = (@gross_total * TAX_RATE).round(2)
  end

  def update_total(item, quantity)
    if item.split(' ').any? { |word| word == 'Muffin' }
      @gross_total = @gross_total.round(2) + ((menu[item] * quantity).round(2) * 0.9).round(2)
    else
      @gross_total += (menu[item] * quantity).round(2)
    end
  end

  def calculate_net_total
    calculate_tax
    @net_total = (@gross_total + @tax).round(2)
  end

  def receipt_check_and_add(item, quantity)
    receipt.key?(item) ? receipt[item] += quantity : receipt[item] = quantity
  end

end