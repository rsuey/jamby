class GroupSession < ActiveRecord::Base
  belongs_to :host, class_name: 'User'
  has_many :payments, -> { not_deleted }
  has_many :bookings
  has_many :participants, through: :bookings, source: :user

  validates :title, :description, :starts_at, presence: true

  delegate :name, to: :host, prefix: true, allow_nil: true

  scope :upcoming, -> { where('starts_at > ?', Time.current) }
  scope :live, -> { where('starts_at <= ?', Time.current) }

  def live_details_ready?
    live_url.present? && broadcast_id.present?
  end

  def broadcast_embed
    "//youtube.com/embed/#{broadcast_id}"
  end

  def price_in_pennies
    price * 100
  end

  def ready_to_start?
    starts_at <= 15.minutes.from_now
  end

  def paid?(account)
    free? or payments.collect(&:account).include?(account)
  end

  def free?
    price.zero?
  end

  def can_be_booked_by?(user)
    host != user and not booked_by?(user)
  end

  def booked_by?(user)
    participants.include?(user)
  end
end
