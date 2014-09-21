class AddBrandToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :brand, :string
  end
end
