class GroupSessionPage < PageObject
  def initialize(group_session)
    @group_session = group_session
  end

  def path
    group_session_path(@group_session)
  end

  def form_button
    t('forms.models.group_session.edit')
  end

  def click_edit_link
    click_link t('links.models.group_session.edit')
  end

  def after_successful_edit_path
    path
  end

  def session_selector
    "##{dom_id(@group_session)}"
  end

  def date_selector
    '.group_session_meta time .group_session_meta_date'
  end

  def time_selector
    '.group_session_meta time .group_session_meta_time'
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
