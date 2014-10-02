require 'rails_helper'

describe Payment do
  it 'refunds charges on deletion' do
    refund = double(id: 're_123abc')
    payment = create(:payment, remote_id: 'ch_123abc')

    allow(Charge).to receive(:refund) { refund }
    payment.destroy

    expect(Charge).to have_received(:refund).with('ch_123abc')
    expect(payment.reload.remote_refund_id).to eq('re_123abc')
  end
end
