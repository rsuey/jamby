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

  def confirm_payment_button_text
    t('forms.models.payment.create')
  end

  def session_booked_text
    t('text.models.group_session.booked')
  end

  def successful_booking_text
    t('controllers.group_sessions.book.successful')
  end

  def click_edit_link
    click_link t('links.models.group_session.edit')
  end

  def book_link_text
    t('links.models.group_session.book_now')
  end

  def confirm_delete
    click_link t('links.models.group_session.delete')
  end

  def after_successful_book_path
    path
  end

  def after_successful_edit_path
    path
  end

  def after_successful_delete_path
    root_path
  end

  def session_list_selector
    '#group_sessions'
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
