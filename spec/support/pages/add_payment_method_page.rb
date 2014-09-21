class AddPaymentMethodPage < PageObject
  def new_payment_method_link_text
    t('links.models.payment_method.new')
  end

  def form_button
    t('forms.models.payment_method.create')
  end

  def after_successful_add_path
    dashboard_account_path
  end
end
