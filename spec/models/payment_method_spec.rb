require 'rails_helper'

describe PaymentMethod do
  describe '#destroy' do
    it 'destroys the customer' do
      VCR.use_cassette('create a payment method') do
        payment_method = create(:payment_method)
        allow(Customer).to receive(:delete)

        payment_method.destroy
        expect(Customer).to have_received(:delete).with(payment_method.remote_id)
      end
    end
  end

  describe '#save' do
    context 'when the card number is invalid' do
      let(:payment_method) { build(:payment_method, number: '123abc') }

      it 'returns false' do
        VCR.use_cassette('validate card number') do
          expect(payment_method).to_not be_valid
          expect(payment_method.save).to eq(false)
        end
      end

      it 'adds the error to the payment method' do
        VCR.use_cassette('validate card number') do
          payment_method.valid?
          expect(payment_method.errors.full_messages)
            .to include('This card number looks invalid')
        end
      end
    end

    context 'when the expiration year is invalid' do
      let(:payment_method) { build(:payment_method, exp_year: 13) }

      it 'returns false' do
        VCR.use_cassette('validate expiration year') do
          expect(payment_method).to_not be_valid
          expect(payment_method.save).to eq(false)
        end
      end

      it 'adds the error to the payment method' do
        VCR.use_cassette('validate expiration year') do
          payment_method.valid?
          expect(payment_method.errors.full_messages)
            .to include("Your card's expiration year is invalid.")
        end
      end
    end

    context 'when the expiration month is invalid' do
      let(:payment_method) { build(:payment_method,
                                   exp_month: Time.current.month - 1,
                                   exp_year: Time.current.year) }

      it 'returns false' do
        VCR.use_cassette('validate expiration month') do
          expect(payment_method).to_not be_valid
          expect(payment_method.save).to eq(false)
        end
      end

      it 'adds the error to the payment method' do
        VCR.use_cassette('validate expiration month') do
          payment_method.valid?
          expect(payment_method.errors.full_messages)
            .to include("Your card's expiration month is invalid.")
        end
      end
    end
  end
end
