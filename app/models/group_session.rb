class GroupSession < ActiveRecord::Base
  HOST_PAYOUT_RATE = 0.8

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
  scope :unpaid_out, -> { where('paid_out_at IS NULL') }

  before_save :generate_hashed_id
  after_save :refund_price_difference, if: :price_changed?
  after_create :schedule_completion_job

  friendly_id :hashed_id, use: :finders

  def payout!
    update_attributes(paid_out_at: Time.current)
  end

  def payout_value
    if paid_out? or not completed?
      0
    else
      (total_value * HOST_PAYOUT_RATE).round(2)
    end
  end

  def paid_out?
    paid_out_at.present?
  end

  def total_value
    (payments.sum(:amount) / 100.0).round(2) # payment amounts are in pennies
  end

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

  def bookable_by?(user)
    host != user and not booked_by?(user)
  end

  def booked_by?(user)
    participants.include?(user)
  end

  def completed?
    ended_at.present?
  end

  def complete!
    update_attributes(ended_at: Time.current)
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
    participants.each do |participant|
      ParticipantNotifier.price_reduced(self, participant, price_was).deliver
    end
  end

  def generate_hashed_id
    GenerateToken.apply(self, :hashed_id)
  end

  def schedule_completion_job
    jid = CompleteGroupSessionWorker.perform_at(starts_at + 1.hour, id)
    update_attributes(completion_job_id: jid)
  end
end
