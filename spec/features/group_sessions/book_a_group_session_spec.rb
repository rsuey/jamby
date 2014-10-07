require 'rails_helper'

feature 'User books a group session' do
  scenario 'Booked sessions show their guest list' do
    group_session = create(:group_session)
    userA = create(:user, first_name: 'Bob')
    userB = create(:user, first_name: 'Gary')

    Booking.create(group_session, userA)
    Booking.create(group_session, userB)

    visit group_session_path(group_session)

    within('#guest_list') do
      expect(page).to have_content('Bob')
      expect(page).to have_content('Gary')
    end
  end

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
      user = create(:account)
      group_session = create(:group_session, price: 1)
      page = GroupSessionPage.new(group_session)

      logged_in(user) do
        create(:payment_method, account: user)

        page.visit
        click_link page.book_link_text

        select 'Visa *1111', from: page.existing_payment_method_label
        within('#existing-payment-method') do
          click_button page.confirm_payment_button_text
        end
      end

      expect(current_path).to eq(page.after_successful_book_path)
      expect(page).to have_css('.alert-box.info',
                               text: page.successful_booking_text)
      within(page.session_selector) do
        expect(page).to have_content(page.session_booked_text)
      end
    end
  end

  scenario 'User books a paid group session with new payment information' do
    VCR.use_cassette('book a paid session with new payment method') do
      user = create(:account)
      group_session = create(:group_session, price: 1)
      page = GroupSessionPage.new(group_session)

      logged_in(user) do
        page.visit
        click_link page.book_link_text

        page.fill_in_form('Name on card' => 'Joe Sak',
                          'Number' => 4242424242424242,
                          'mm' => '08',
                          'yy' => Time.current.year + 1,
                          'CVC' => 123)

        within('#new-payment-method') do
          click_button page.confirm_payment_button_text
        end
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
