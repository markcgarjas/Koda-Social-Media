class Post < ApplicationRecord
  validates_presence_of :text, :audience
  enum audience: { public_post: 0, private_post: 1, friends_only: 2 }
  belongs_to :user
  mount_uploader :image, ImageUploader
  default_scope { order("created_at DESC") }
end
