class GroupSessionsUser < ActiveRecord::Base
  belongs_to :participant
  belongs_to :group_session
end
