class UserGroupsController < ApplicationController
  before_action :set_group_user, only: [:edit, :update, :destroy]
  before_action :set_group

  def show
    authorize @group, :show?, policy_class: UserGroupPolicy
    @admins = @group.user_groups.admin
    @moderators = @group.user_groups.moderator
    @normal_users = @group.user_groups.normal
  end

  def edit
    authorize @group, :edit?, policy_class: UserGroupPolicy
  end

  def update
    authorize @group, :update?, policy_class: UserGroupPolicy
    @user_group.update(group_user_params)
    flash[:notice] = "User update successfully"
    redirect_to group_user_group_path
  end

  def destroy
    authorize @group, :destroy?, policy_class: UserGroupPolicy
    @user_group.destroy
    flash[:notice] = "User deleted successfully"
    redirect_to group_user_group_path
  end

  private

  def set_group_user
    @user_group = UserGroup.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def group_user_params
    params.required(:user_group).permit(:role)
  end
end
