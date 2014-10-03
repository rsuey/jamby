require 'rails_helper'

describe Charge do
  it 'creates charges' do
    group_session = double(:group_session, hashed_id: '123abc')
    user = double(:group_session, name: 'Joe Sak')
    payment = double(:payment, amount: 100, currency: 'usd')
    payment_method = double(:payment_method, remote_id: 'cu_123')

    allow(Stripe::Charge).to receive(:create)
    Charge.create(group_session, user, payment, payment_method)

    expect(Stripe::Charge).to have_received(:create)
                        .with(amount: 100,
                              currency: 'usd',
                              customer: 'cu_123',
                              description: "Group session: 123abc for Joe Sak")
  end

  it 'refunds charges' do
    VCR.use_cassette('refund a stripe charge') do
      refund = Charge.refund('ch_14idZB2L7z1ZOsnrWNam4P1n')
      expect(refund.object).to eq('refund')
      expect(refund.id).to_not be_nil
    end
  end

  it 'partially refunds charges' do
    VCR.use_cassette('partially refund a stripe charge') do
      refund = Charge.refund('ch_14idXK2L7z1ZOsnrZgigMzqt', amount: 50)
      expect(refund.amount).to eq(50) # cents
    end
  end
end
