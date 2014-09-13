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

  def signin_link_text
    t('links.models.signin.new')
  end

  def successful_signin_text
    t('controllers.signins.create.successful')
  end
end
