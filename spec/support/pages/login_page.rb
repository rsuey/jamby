class LoginPage < PageObject
  def path
    signin_path
  end

  def form_button
    t('forms.models.signin.create')
  end
end
