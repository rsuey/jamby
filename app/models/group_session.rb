class GroupSession < ActiveRecord::Base
  belongs_to :host, class_name: 'User'
  has_many :payments
  has_many :bookings
  has_many :participants, through: :bookings, source: :user

  validates :title, :description, :starts_at, presence: true

  delegate :name, to: :host, prefix: true, allow_nil: true

  scope :upcoming, -> { where('starts_at > ?', Time.current) }
  scope :live, -> { where('starts_at <= ?', Time.current) }

  def price_in_pennies
    price * 100
  end

  def ready_to_start?
    starts_at <= 15.minutes.from_now
  end

  def paid?(user)
    free? or payments.collect(&:user).include?(user)
  end

  def free?
    price.zero?
  end

  def can_be_booked_by?(user)
    host != user && !booked_by?(user)
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
