class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum role: { admin: 1, moderator: 2, normal: 3 }
  validates :user, presence: true, uniqueness: { scope: :group }
end
