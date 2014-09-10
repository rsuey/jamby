require 'rails_helper'

feature 'User books a group session' do
  scenario 'User books a free group session' do
    logged_in do
      group_session = create(:group_session)
      page = GroupSessionPage.new(group_session)

      page.visit
      page.click_book_link

      expect(current_path).to eq(page.after_successful_book_path)
      expect(page).to have_css('.alert-box.info',
                               text: page.successful_booking_text)
      within(page.session_selector) do
        expect(page).to have_content(page.session_booked_text)
      end
    end
  end
end
