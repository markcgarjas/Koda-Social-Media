class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :destroy, :edit, :update]

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
    @user = current_user.user_groups.new(group: group)
    @user.role = :normal
    if @user.save
      flash[:notice] = "successfully join!"
      redirect_to groups_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
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
    @group = Group.find(params[:id])
  end
end
