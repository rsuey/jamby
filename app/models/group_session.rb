class GroupSession < ActiveRecord::Base
  has_and_belongs_to_many :participants

  validates :title, :description, :starts_at, presence: true

  def free?
    price.zero?
  end

  def booked_by?(user)
    participants.include?(user)
  end

  def guest_list
    participants
  end

  def add_participant(user)
    unless participants.include?(user)
      participants << user
    end
  end
end
