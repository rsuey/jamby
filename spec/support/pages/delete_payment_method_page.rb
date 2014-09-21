class DeletePaymentMethodPage < PageObject
  def delete_link_text
    t('links.models.payment_method.delete')
  end

  def after_successful_delete_path
    dashboard_account_path
  end
end
