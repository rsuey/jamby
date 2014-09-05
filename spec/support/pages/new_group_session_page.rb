class NewGroupSessionPage < GroupSessionPage
  def initialize
  end

  def path
    new_group_session_path
  end

  def form_button
    t('forms.models.group_session.create')
  end

  def after_successful_create_path
    root_path
  end

  def after_failed_create_path
    group_sessions_path
  end

  def blank_title_error
    "Title " + t('activerecord.errors.models.group_session.attributes.title.blank')
  end

  def blank_description_error
    "Description " + t('activerecord.errors.models.group_session.attributes.description.blank')
  end

  def blank_starts_at_error
    "Starts at " + t('activerecord.errors.models.group_session.attributes.starts_at.blank')
  end

  def form_selector
    '.new_group_session'
  end

  def error_field_css
    '.errors'
  end
end
