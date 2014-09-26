class PaymentMethodFactory
  def self.find_or_create(attributes, persitence_id, account)
    if attributes.values.all?(&:empty?)
      account.payment_methods.find(persitence_id)
    else
      account.payment_methods.create(attributes)
    end
  end
end
