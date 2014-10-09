class GroupSession < ActiveRecord::Base
  extend FriendlyId

  belongs_to :host, class_name: 'User'
  has_many :payments, -> { not_deleted }
  has_many :bookings
  has_many :participants, through: :bookings, source: :user

  validates :title, :description, :starts_at, presence: true

  delegate :name, :email, :avatar, to: :host, prefix: true, allow_nil: true

  scope :upcoming, -> { not_completed.where('starts_at > ?', Time.current) }
  scope :live, -> { not_completed.where('starts_at <= ?', Time.current) }
  scope :not_completed, -> { where('ended_at IS NULL') }
  scope :completed, -> { where('ended_at IS NOT NULL') }
  scope :paid, -> { where('price > 0') }

  before_save :generate_hashed_id
  after_save :refund_price_difference, if: :price_changed?

  friendly_id :hashed_id, use: :finders

  def guest_list
    participants
  end

  def fully_booked?
    participants.size == 10
  end

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

  def completed?
    ended_at.present?
  end

  private
  def refund_price_difference
    difference = price_was - price
    difference = (difference * 100).to_i # must be in cents
    if difference > 0
      payments.find_each { |p| p.refund(difference) }
      notify_participants_of_price_reduction
    end
  end

  def notify_participants_of_price_reduction
    participants.each { |p| ParticipantNotifier.price_reduced(self, p).deliver }
  end

  def generate_hashed_id
    return true unless hashed_id.blank?
    begin
      self.hashed_id = SecureRandom.base64[0..6]
    end while self.class.exists?(hashed_id: hashed_id)
  end
end
