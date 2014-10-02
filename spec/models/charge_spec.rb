require 'rails_helper'

describe Charge do
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
