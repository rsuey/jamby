require 'rails_helper'

feature 'Host a group session', :js do
  scenario 'Host starts a hangout' do
    user = create(:host)
    group_session = create(:group_session, host: user,
                                           starts_at: 15.minutes.from_now)
    page = GroupSessionPage.new(group_session)

    logged_in(user) { page.visit }

    iframeId = page.evaluate_script('$("iframe").first().attr("id")')
    within_frame(iframeId) do
      expect(page).to have_content('Start a Hangout On Air')
    end
  end

  scenario 'A session is not ready to start' do
    user = create(:host)
    group_session = create(:group_session, host: user,
                                           starts_at: 16.minutes.from_now)
    page = GroupSessionPage.new(group_session)

    logged_in(user) { page.visit }

    iframeId = page.evaluate_script('$("iframe").first().attr("id")')
    expect(iframeId).to be_nil
  end
end
