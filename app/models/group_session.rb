class GroupSession < ActiveRecord::Base
  belongs_to :host, class_name: 'User'
  has_many :bookings
  has_many :participants, through: :bookings, source: :user

  validates :title, :description, :starts_at, presence: true

  delegate :name, to: :host, prefix: true, allow_nil: true

  def free?
    price.zero?
  end

  def booked_by?(user)
    guest_list.include?(user)
  end

  def add_participant(user)
    unless booked_by?(user)
      guest_list << user
      save
    end
  end

  def guest_list
    participants
  end
end
