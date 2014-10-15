require 'rails_helper'

feature 'User creates a group session' do
  scenario 'Creating a free group session' do
    page = NewGroupSessionPage.new
    year = Time.current.year + 1
    dayname = DateTime.new(year, 1, 31).to_s(:dayname)
    user = create(:signup)

    logged_in(user) do
      page.visit
      page.fill_in_form('Title' => 'Free session',
                        'Description' => 'This group session is free!',
                        'group_session_starts_at_1i' => year,
                        'group_session_starts_at_2i' => 'January',
                        'group_session_starts_at_3i' => 31,
                        'group_session_starts_at_4i' => '05 PM',
                        'group_session_starts_at_5i' => '00',
                        'Price' => nil)
      page.submit_form
    end

    expect(current_path).to eq(page.after_successful_create_path)
    within(page.session_list_selector) do
      expect(page).to have_css(page.host_name_selector, text: user.name)
      expect(page).to have_css(page.title_selector, text: 'Free session')
      expect(page).to have_css(page.description_selector,
                               text: 'This group session is free!')
      expect(page).to have_css(page.date_selector, text: "#{dayname}, Jan 31")
      expect(page).to have_css(page.time_selector, text: '5:00pm')
    end
  end

  scenario 'Creating an invalid group session' do
    page = NewGroupSessionPage.new

    logged_in do
      page.visit
      page.fill_in_form({})
      page.submit_form
    end

    expect(current_path).to eq(page.after_failed_create_path)
    within(page.error_field_css) do
      expect(page).to have_content(page.blank_title_error)
      expect(page).to have_content(page.blank_description_error)
    end
  end
end
