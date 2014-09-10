module SigninHelper
  def logged_in
    signin = create(:signin)
    page = LoginPage.new
    page.visit
    page.fill_in_form(username: signin.username, password: signin.password)
    page.submit_form
    yield(signin)
  end
end
