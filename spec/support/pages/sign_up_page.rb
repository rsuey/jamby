class SignUpPage < PageObject
  def path
    new_signup_path
  end

  def form_button
    t('forms.models.signup.create')
  end

  def after_successful_signup_path
    root_path
  end

  def successful_signup_text
    t('controllers.signups.create.successful')
  end
end
