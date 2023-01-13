class UserGroup < ApplicationRecord
  include AASM
  after_create :approve_when_group_is_public
  belongs_to :user
  belongs_to :group
  belongs_to :inviter, class_name: 'User', optional: true
  has_many :group_posts
  enum role: { admin: 1, moderator: 2, normal: 3 }
  validates :user, presence: true, uniqueness: { scope: :group }

  aasm column: :state do
    state :pending, initial: true
    state :approved, :cancelled, :declined, :invited, :accepted, :deleted

    event :pend do
      transitions from: [:cancelled, :declined, :deleted], to: :pending
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

    event :accept do
      transitions from: :invited, to: :accepted
    end

    event :delete do
      transitions from: :invited, to: :deleted
    end
  end

  def approve_when_group_is_public
    self.update(state: :approved) if group.public_group?
  end
end
