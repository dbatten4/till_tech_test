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

  it 'should calculate total tax' do
    subject.take_order('Cafe Latte', 1)
    subject.finalise_order
    expect(subject.tax).to eq(0.41)
  end

  it 'should increment the quantity of item if the item is added twice or more' do 
    subject.take_order('Cafe Latte', 1)
    subject.take_order('Cafe Latte', 1)
    subject.take_order('Cafe Latte', 1)
    expect(subject.receipt).to eq({'Cafe Latte' => 3})
  end

  it 'should be able to finalise the order which will update the net total' do 
    subject.take_order('Cafe Latte', 2)
    subject.take_order('Tiramisu', 1)
    subject.finalise_order
    expect(subject.net_total).to eq(22.71)
  end

end