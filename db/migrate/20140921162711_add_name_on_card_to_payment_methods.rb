class AddNameOnCardToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :name_on_card, :string
  end
end
