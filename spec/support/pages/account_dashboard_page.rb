class AccountDashboardPage < PageObject
  def path
    dashboard_account_path
  end

  def form_button
    t('forms.models.account.update')
  end

  def edit_profile_link_text
    t('links.models.account.edit')
  end

  def delete_account_link_text
    t('links.models.account.destroy')
  end

  def successful_delete_text
    t('controllers.accounts.destroy.successful')
  end

  def after_successful_profile_edit_path
    dashboard_account_path
  end

  def after_successful_delete_path
    root_path
  end
end
