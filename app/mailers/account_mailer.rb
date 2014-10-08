class AccountMailer < ActionMailer::Base
  default from: 'support@jamby.co'

  # en.account_mailer.password_reset.subject
  def password_reset(account)
    @url = new_password_url(token: account.password_reset_token)
    mail to: account.email
  end
end
