class GroupPost < ApplicationRecord
  include AASM
  validates_presence_of :content
  belongs_to :group
  belongs_to :user_group
  mount_uploader :image, ImageUploader

  aasm column: :state do
    state :pending, initial: true
    state :published, :removed

    event :publish do
      transitions from: :pending, to: :published
    end

    event :remove do
      transitions from: :pending, to: :removed
    end
  end
end
