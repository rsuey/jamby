class GroupSessionsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group_session
end
