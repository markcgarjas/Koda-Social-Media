class UserGroup < ApplicationRecord
  include AASM
  after_create :approve_when_group_is_public
  belongs_to :user
  belongs_to :group
  enum role: { admin: 1, moderator: 2, normal: 3 }
  validates :user, presence: true, uniqueness: { scope: :group }

  aasm column: :state do
    state :pending, initial: true
    state :approved, :cancelled, :declined

    event :pend do
      transitions from: [:cancelled, :declined], to: :pending
    end

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :decline do
      transitions from: :pending, to: :declined
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
    end
  end

  def approve_when_group_is_public
    self.update(state: :approved) if group.public_group?
  end
end
