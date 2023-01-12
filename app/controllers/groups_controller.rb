class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :destroy, :edit, :update, :cancel, :join_group]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    authorize @group, :show?, policy_class: GroupPolicy
  end

  def join_group
    group = Group.find(params[:group_id])
    @user = current_user.user_groups.find_by(group: group)
    if @user
      @user.pend!
      flash[:notice] = "successfully join!"
      redirect_to groups_path
    else
      @user_group = UserGroup.new
      @user_group.user = current_user
      @user_group.group = @group
      @user_group.role = :normal
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

end
