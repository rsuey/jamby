require 'rails_helper'

feature 'User books a group session' do
  scenario 'User books a free group session' do
    group_session = create(:group_session)
    page = GroupSessionPage.new(group_session)

    logged_in do
      page.visit
      click_link page.book_link_text
    end

    expect(current_path).to eq(page.after_successful_book_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_booking_text)
    within(page.session_selector) do
      expect(page).to have_content(page.session_booked_text)
    end
  end

  scenario 'User books a paid group session' do
    VCR.use_cassette('book a paid session') do
      group_session = create(:group_session, price: 1)
      page = GroupSessionPage.new(group_session)

      logged_in do |user|
        create(:payment_method, user: user)

        page.visit
        click_link page.book_link_text

        select 'Visa *1111', from: 'Payment method'
        click_button page.confirm_payment_button_text
      end

      expect(current_path).to eq(page.after_successful_book_path)
      expect(page).to have_css('.alert-box.info',
                               text: page.successful_booking_text)
      within(page.session_selector) do
        expect(page).to have_content(page.session_booked_text)
      end
    end
  end
end
