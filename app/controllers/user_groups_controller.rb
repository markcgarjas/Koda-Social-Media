class UserGroupsController < ApplicationController
  before_action :set_group_user, only: [:edit, :update, :destroy, :approve, :decline]
  before_action :set_group
  before_action :set_group_post, only: [:publish, :remove]

  def show
    authorize @group, :show?, policy_class: UserGroupPolicy
    @admins = @group.user_groups.admin
    @moderators = @group.user_groups.moderator
    @normal_users = @group.user_groups.normal.approved.or(@group.user_groups.normal.accepted)
    @pending_members = @group.user_groups.pending
    @invited_members = @group.user_groups.invited
    @pending_posts = @group.group_posts.pending
  end

  def edit
    authorize @group, :edit?, policy_class: UserGroupPolicy
  end

  def approve
    authorize @group, :approve?, policy_class: UserGroupPolicy
    if @user_group.may_approve? && @user_group.approve!
      flash[:notice] = "Successfully Accept"
      redirect_to group_user_group_path(@group, @user_group)
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to group_user_group_path(@group, @user_group)
    end
  end

  def decline
    authorize @group, :decline?, policy_class: UserGroupPolicy
    if @user_group.may_decline? && @user_group.decline!
      flash[:notice] = "Successfully Decline"
      redirect_to group_user_group_path(@group, @user_group)
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to group_user_group_path(@group, @user_group)
    end
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
    @user_group = UserGroup.find(params[:id] || params[:user_group_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_post
    @group_post = GroupPost.find(params[:id] || params[:group_post_id])
  end

  def group_user_params
    params.required(:user_group).permit(:role)
  end
end
