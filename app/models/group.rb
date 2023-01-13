class Group < ApplicationRecord
  after_create :default_admin
  after_create :enable_invite
  validates_presence_of :description, :banner, :privacy
  validates :description, presence: true, length: { minimum: 15 }
  validates :name, presence: true, uniqueness: true
  belongs_to :owner, class_name: 'User'
  has_many :user_groups
  has_many :users, class_name: 'User', through: :user_groups
  has_many :group_posts
  enum privacy: { public_group: 0, hidden_group: 1 }
  mount_uploader :banner, ImageUploader

  def default_admin
    UserGroup.create!(role: :admin, group: self, user: owner, state: :approved)
  end

  def enable_invite
    self.update(can_invite?: true) if self.hidden_group?
  end
end
