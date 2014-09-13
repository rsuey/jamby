class SignInPage < PageObject
  def path
    signin_path
  end

  def form_button
    t('forms.models.signin.create')
  end

  def after_successful_signin_path
    root_path
  end

  def after_failed_signin_path
    signins_path
  end

  def after_successful_signout_path
    root_path
  end

  def invalid_credentials_text
    t('controllers.signins.create.failure')
  end

  def signin_link_text
    t('links.models.signin.new')
  end

  def signout_link_text
    t('links.models.signin.destroy')
  end

  def successful_signin_text
    t('controllers.signins.create.successful')
  end

  def successful_signout_text
    t('controllers.signins.destroy.successful')
  end
end
