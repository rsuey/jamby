module SigninHelper
  def logged_in(user = create(:signup))
    page = LoginPage.new
    page.visit
    page.fill_in_form('Email' => user.email,
                      'Password' => user.password)
    page.submit_form
    yield(user)
  end
end
