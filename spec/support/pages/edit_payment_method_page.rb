class EditPaymentMethodPage < PageObject
  def edit_link_text
    t('links.models.payment_method.edit')
  end

  def form_button
    t('forms.models.payment_method.update')
  end

  def after_successful_edit_path
    dashboard_account_path
  end
end
