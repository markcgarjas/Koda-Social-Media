class AddColumnStateToGroupPost < ActiveRecord::Migration[7.0]
  def change
    add_column :group_posts, :state, :string
  end
end
