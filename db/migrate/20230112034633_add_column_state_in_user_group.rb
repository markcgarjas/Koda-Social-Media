class AddColumnStateInUserGroup < ActiveRecord::Migration[7.0]
  def change
    add_column :user_groups, :state, :string
  end
end
