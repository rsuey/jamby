class Customer
  def initialize(customer)
    @customer = customer
  end

  def id
    @customer.id
  end

  def last_four_of_card
    @customer.cards.data[0].last4
  end

  def self.create(payment_method, user)
    begin
      new(Stripe::Customer.create(card: { name: payment_method.name_on_card,
                                          number: payment_method.number,
                                          cvc: payment_method.cvc,
                                          exp_month: payment_method.exp_month,
                                          exp_year: payment_method.exp_year },
                                  description: user.email))
    rescue Stripe::CardError => e
      raise Customer::CardError.new(e.message, e.http_status, e.http_body)
    end
  end

  class CardError < Stripe::CardError; end
end
