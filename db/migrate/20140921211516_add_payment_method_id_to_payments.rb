class AddPaymentMethodIdToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :payment_method, index: true
  end
end
