class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.references :owner
      t.string :name
      t.integer :privacy
      t.string :description
      t.string :banner
      t.boolean :can_invite?
      t.timestamps
    end
  end
end
