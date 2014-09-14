class GroupSessionsPage < PageObject
  def path
    group_sessions_path
  end

  def live_sessions_title
    t('text.models.group_session.titles.live')
  end

  def upcoming_sessions_title
    t('text.models.group_session.titles.upcoming')
  end
end
