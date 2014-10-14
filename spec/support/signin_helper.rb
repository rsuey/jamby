module SigninHelper
  def logged_in(user = create(:signin))
    page = SignInPage.new
    page.visit
    page.fill_in_form('Email' => user.email,
                      'Password' => user.password)
    page.submit_form
    yield(user)
  end

  def sign_out
    page.click_link 'Log out'
  end
end
