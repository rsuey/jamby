require 'spec_helper'
require 'stripe'
require './app/models/customer'

describe Customer do
  describe '.delete' do
    it 'deletes the customer' do
      customer = double(:customer)

      allow(Stripe::Customer).to receive(:retrieve).with('123abc') { customer }
      allow(customer).to receive(:delete)
      Customer.delete('123abc')

      expect(customer).to have_received(:delete)
    end
  end
end
