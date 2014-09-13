class AccountDashboardPage < PageObject
  def path
    dashboard_account_path
  end

  def delete_account_link_text
    t('links.models.account.destroy')
  end

  def successful_delete_text
    t('controllers.accounts.destroy.successful')
  end

  def after_successful_delete_path
    root_path
  end
end
