class NewGroupSessionPage
  include ActionView::Helpers
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit
    super(new_group_session_path)
  end

  def fill_in_form(attributes)
    attributes.each do |name, value|
      fill_in name.to_s.capitalize, with: value
    end
  end

  def submit_form
    click_button t('forms.models.group_sessions.create')
  end

  def after_successful_create_path
    root_path
  end

  def session_list_selector
    '#group_sessions'
  end

  def title_selector
    '.group_session_info_title'
  end

  def description_selector
    '.group_session_info_description'
  end

  def price_selector
    '.group_session_meta_price'
  end
end
