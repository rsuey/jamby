class GroupSessionsUser < ActiveRecord::Base
  belongs_to :participant, polymorphic: true
  belongs_to :group_session
end
