class GroupSession < ActiveRecord::Base
  validates :title, :description, :starts_at, presence: true

  def free?
    price.zero?
  end
end
