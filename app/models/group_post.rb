class GroupPost < ApplicationRecord
  validates_presence_of :content
  belongs_to :group
  belongs_to :user_group
  mount_uploader :image, ImageUploader
end
