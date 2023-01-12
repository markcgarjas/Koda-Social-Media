class AddInviterIdToUserGroup < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_groups, :inviter
  end
end
