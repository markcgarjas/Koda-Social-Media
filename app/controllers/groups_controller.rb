class GroupsController < ApplicationController
  before_action :set_group, except: [:index, :new, :create]
  before_action :set_user, only: :invite_user

  def index
    @groups = Group.public_group if params[:group] == 'public'
    @join_groups = Group.includes(:user_groups).where(user_groups: { state: [:accepted, :approved], user: current_user }).or(Group.where(owner: current_user)) if params[:group] == 'join'
    @group_invitations = Group.includes(:user_groups).where(user_groups: { state: :invited, user: current_user }) if params[:group] == 'invitation'
  end

  def new
    @group = Group.new
  end

  def show
    @group_post = GroupPost.new
    authorize @group, :show?, policy_class: GroupPolicy
    @group_posts = @group.group_posts.published
    @friend_lists = current_user.friends.where.not(id: @group.user_groups.where(state: [:pending, :approved, :invited, :accepted]).pluck(:user_id))
  end

  def invite_user
    @user_group = @user.user_groups.find_by(group: @group)
    if @user_group
      @user_group.inviter = current_user
      @user_group.state = :invited
      flash[:notice] = "successfully invited!"
      redirect_to groups_path
    else
      @user_group = UserGroup.new
      @user_group.user = @user
      @user_group.group = @group
      @user_group.role = :normal
      @user_group.state = :invited
      @user_group.inviter = current_user
      if @user_group.save
        flash[:notice] = "successfully invited!"
        redirect_to groups_path
      else
        flash[:alert] = @user_group.errors.full_messages.join(", ")
        redirect_to groups_path
      end
    end
  end

  def join_group
    @user_group = current_user.user_groups.find_by(group: @group)
    if @user_group && @user_group.pend!
      flash[:notice] = "successfully join!"
      redirect_to groups_path
    else
      @user_group = UserGroup.new
      @user_group.user = current_user
      @user_group.role = :normal
      @user_group.group = @group
      if @user_group.save
        flash[:notice] = "successfully join!"
        redirect_to groups_path
      else
        flash[:alert] = @user_group.errors.full_messages.join(", ")
        redirect_to groups_path
      end
    end
  end

  def cancel
    authorize @group, :cancel?, policy_class: GroupPolicy
    if @group.user_groups.where(user: current_user).each do |user_group|
      user_group.may_cancel? && user_group.cancel!
    end
      flash[:notice] = "Successfully Cancel"
      redirect_to groups_path
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to groups_path
    end
  end

  def accept
    authorize @group, :accept?, policy_class: GroupPolicy
    if @group.user_groups.where(user: current_user).each do |user_group|
      user_group.may_accept? && user_group.accept!
    end
      flash[:notice] = "Successfully Accept Invitation"
      redirect_to groups_path
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to groups_path
    end
  end

  def delete
    authorize @group, :delete?, policy_class: GroupPolicy
    if @group.user_groups.where(user: current_user).each do |user_group|
      user_group.may_delete? && user_group.delete!
    end
      flash[:notice] = "Successfully Delete Invitation"
      redirect_to groups_path
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to groups_path
    end
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    if @group.save
      flash[:notice] = "#{@group.name} was create successfully"
      redirect_to groups_path
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to groups_path
    end
  end

  def edit
    authorize @group, :edit?, policy_class: GroupPolicy
  end

  def update
    authorize @group, :edit?, policy_class: GroupPolicy
    if @group.update(group_params)
      flash[:notice] = "#{@group.name} was update successfully"
      redirect_to group_path(@group)
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to groups_path(@group)
    end
  end

  def destroy
    authorize @group, :destroy?, policy_class: GroupPolicy
    if @group.destroy
      flash[:notice] = "#{@group.name} was deleted successfully"
      redirect_to groups_path
    else
      flash[:notice] = @group.errors.full_messages.join(", ")
      redirect_to groups_path
    end
  end

  private

  def group_params
    params.required(:group).permit(:name, :privacy, :banner, :description, :role)
  end

  def set_group
    @group = Group.find(params[:id] || params[:group_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
