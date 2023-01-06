class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user
      t.integer :audience
      t.string :text
      t.string :image
      t.string :location
      t.timestamps
    end
  end
end
