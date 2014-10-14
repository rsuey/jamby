require 'rails_helper'

describe PayoutAccount do
  describe '#transfer' do
    it 'sends a transfer to the remote recipient' do
      payout_account = build(:payout_account, remote_id: 'abc123')

      allow(Recipient).to receive(:transfer)
      payout_account.transfer(50)
      expect(Recipient).to have_received(:transfer).with('abc123', 5000)
    end
  end

  it 'requires a name and banking information' do
    payout_account = PayoutAccount.new

    expect(payout_account).not_to be_valid

    errors = payout_account.errors
    expect(errors[:name][0]).to include('blank')
    expect(errors[:country][0]).to include('blank')
    expect(errors[:routing_number][0]).to include('blank')
    expect(errors[:account_number][0]).to include('blank')
  end

  it 'defaults to individual account type' do
    payout_account = PayoutAccount.new
    expect(payout_account.account_type).to eq('individual')
  end

  it 'uses a display name' do
    payout_account = PayoutAccount.new(bank_name: 'Blah', last4: '1234')
    expect(payout_account.display_name).to eq('Blah xxxxx1234')
  end

  it 'fills in information from Stripe response' do
    VCR.use_cassette('fill in information from Stripe') do
      payout_account = create(:payout_account, account_number: '000123456789')
      expect(payout_account.remote_id).to match(/\Arp_[\w\d]+\z/)
      expect(payout_account.last4).to eq(6789)
      expect(payout_account.bank_name).to eq('STRIPE TEST BANK')
    end
  end
end
