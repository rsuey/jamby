require 'rails_helper'

feature 'Forgot password' do
  scenario 'reset password' do
    user = create(:signup)

    visit new_password_reset_path
    fill_in 'Email', with: user.email
    click_button I18n.t('forms.models.password_reset.new')

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(user.email)
    expect(mail.subject).to eq('Password reset')

    visit new_password_path(token: user.reload.password_reset_token)
    fill_in 'Password', with: 'newSecret89'
    fill_in 'Password confirmation', with: 'newSecret89'
    click_button I18n.t('forms.models.password.new')

    expect(current_path).to eq(root_path)
    expect(user.reload.authenticate('newSecret89')).to be_truthy
  end
end
