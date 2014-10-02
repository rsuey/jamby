require 'rails_helper'

describe Payment do
  it 'implements a refund function' do
    refund = double(id: 're_123abc')
    payment = create(:payment, remote_id: 'ch_123abc')

    allow(Charge).to receive(:refund) { refund }
    payment.refund(1)

    expect(Charge).to have_received(:refund).with('ch_123abc', amount: 1)
    expect(payment.reload.remote_refund_id).to eq('re_123abc')
  end

  it 'refunds charges on deletion' do
    payment = create(:payment, remote_id: 'ch_123abc')

    allow(payment).to receive(:refund)
    payment.destroy

    expect(payment).to have_received(:refund) # full amount
  end
end
