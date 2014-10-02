require 'rails_helper'

describe Charge do
  it 'refunds charges' do
    VCR.use_cassette('refund a stripe charge') do
      refund = Charge.refund('ch_14idZB2L7z1ZOsnrWNam4P1n')
      expect(refund.object).to eq('refund')
      expect(refund.id).to_not be_nil
    end
  end
end
