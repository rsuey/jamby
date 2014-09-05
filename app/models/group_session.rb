class GroupSession < ActiveRecord::Base
  validates :title, :description, :starts_at, presence: true
end
