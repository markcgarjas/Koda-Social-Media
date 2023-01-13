class CreateGroupPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :group_posts do |t|
      t.references :group
      t.references :user_group
      t.string :content
      t.string :image
      t.string :location
      t.timestamps
    end
  end
end
