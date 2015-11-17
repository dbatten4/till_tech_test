require 'order'

describe Order do 

  it { is_expected.to respond_to(:take_order).with(2).arguments }

  it 'should save the order and the quantity' do 
    subject.take_order('Cafe Latte', 1)
    expect(subject.receipt).to eq({'Cafe Latte' => 1})
  end

  it 'returns a fail message if user orders something not on the menu' do
    expect{ subject.take_order('Chicken katsu', 1) }.to raise_error('Not on menu')
  end

  it 'should calculate gross total price' do
    subject.take_order('Cafe Latte', 2)
    subject.take_order('Tiramisu', 1)
    expect(subject.gross_total).to eq(20.9)
  end

  it 'should be able to finalise the order which will calculate total tax' do
    subject.take_order('Cafe Latte', 1)
    subject.finalise_order
    expect(subject.tax).to eq(0.41)
  end

  it 'should be able to calculate the net total' do 
    subject.take_order('Cafe Latte', 2)
    subject.take_order('Tiramisu', 1)
    subject.finalise_order
    expect(subject.net_total).to eq(22.71)
  end

  it 'should increment the quantity of item if the item is added twice or more' do 
    subject.take_order('Cafe Latte', 1)
    subject.take_order('Cafe Latte', 1)
    subject.take_order('Cafe Latte', 1)
    expect(subject.receipt).to eq({'Cafe Latte' => 3})
  end

  it 'should not be able to take payment unless order has been finalised' do 
    subject.take_order('Cafe Latte', 2)
    subject.take_order('Tiramisu', 1)
    expect { subject.take_payment(20) }.to raise_error('Order has not been finalised')
  end
  

  it 'should not be able to take payment of less than the net total' do 
    subject.take_order('Cafe Latte', 2)
    subject.take_order('Tiramisu', 1)
    subject.finalise_order
    expect { subject.take_payment(1) }.to raise_error('Insufficient payment')
  end

  it 'should be able to take payment and calculate correct change' do 
    subject.take_order('Cafe Latte', 2)
    subject.take_order('Tiramisu', 1)
    subject.finalise_order
    expect(subject.take_payment(30)).to eq(7.29)
  end

  it 'should add a 5% discount to orders over $50' do 
    subject.take_order('Affogato', 4)
    subject.finalise_order
    expect(subject.gross_total).to eq(56.24)
  end

  it 'should add 10% discount on all muffins' do 
    subject.take_order('Blueberry Muffin', 1)
    subject.take_order('Chocolate Chip Muffin', 1)
    subject.take_order('Muffin Of The Day', 1)
    expect(subject.gross_total).to eq(11.39)
  end

end