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

  def self.update(payment_method)
    begin
      customer = Stripe::Customer.retrieve(payment_method.remote_id)
      build_card(customer, payment_method)
      customer.save
      new(customer)
    rescue Stripe::CardError => e
      raise Customer::CardError.new(e.message, e.http_status, e.http_body)
    end
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

  private
  def self.build_card(customer, payment_method)
    attributes = {}
    attributes[:number] = payment_method.number unless payment_method.number.blank?
    attributes[:exp_month] = payment_method.exp_month
    attributes[:exp_year] = payment_method.exp_year
    attributes[:cvc] = payment_method.cvc unless payment_method.cvc.blank?
    customer.card = attributes
  end

  class CardError < Stripe::CardError; end
end
