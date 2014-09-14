module SigninHelper
  def logged_in(signin = create(:signin))
    page = LoginPage.new
    page.visit
    page.fill_in_form('Username' => signin.username,
                      'Password' => signin.password)
    page.submit_form
    yield(signin)
  end
end
