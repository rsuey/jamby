module SigninHelper
  def logged_in(user = create(:signin))
    page = SignInPage.new
    page.visit
    page.fill_in_form('Email' => user.email,
                      'Password' => user.password)
    page.submit_form
    yield(user)
  end
end
