class NewGroupSessionPage
  include ActionView::Helpers
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit
    super(path)
  end

  def fill_in_form(attributes)
    attributes.each do |name, value|
      fill_in name.to_s.humanize, with: value
    end
  end

  def submit_form
    click_button t('forms.models.group_sessions.create')
  end

  def after_successful_create_path
    root_path
  end

  def after_failed_create_path
    group_sessions_path
  end

  def blank_title_error
    t('activerecord.errors.models.group_session.attributes.title.blank')
  end

  def blank_description_error
    t('activerecord.errors.models.group_session.attributes.description.blank')
  end

  def blank_starts_at_error
    t('activerecord.errors.models.group_session.attributes.starts_at.blank')
  end

  def form_selector
    '.new_group_session'
  end

  def error_field_css
    '.errors'
  end

  def date_selector
    '.group_session_meta time .group_session_meta_date'
  end

  def time_selector
    '.group_session_meta time .group_session_meta_time'
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

  private
  def path
    new_group_session_path
  end
end
