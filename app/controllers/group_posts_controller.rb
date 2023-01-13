class GroupPostsController < ApplicationController
  before_action :set_group
  before_action :set_group_post, except: :create

  def show
    authorize @group_post, :show?, policy_class: GroupPostPolicy
  end

  def edit
    authorize @group_post, :edit?, policy_class: GroupPostPolicy
  end

  def update
    authorize @group_post, :edit?, policy_class: GroupPostPolicy
    if @group_post.update(params_group_post)
      flash[:notice] = "Group Post update successfully"
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  def create
    @group_post = @group.group_posts.build(params_group_post)
    @group_post.user_group = @group.user_groups.find_by(user: current_user)
    if Rails.env.development?
      @group_post.location = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @group_post.location = request.remote_ip
    end
    if @group_post.save
      flash[:notice] = "Group post was created successfully."
      redirect_to group_path(@group)
    else
      flash[:alert] = @group_post.errors.full_messages.join(", ")
      redirect_to group_path(@group)
    end
  end

  def destroy
    authorize @group_post, :destroy?, policy_class: GroupPostPolicy
    if @group_post.destroy
      flash[:notice] = "Group Post delete successfully"
      redirect_to group_path(@group)
    else
      flash[:alert] = @group_post.errors.full_messages.join(", ")
      redirect_to group_path(@group)
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_post
    @group_post = GroupPost.find(params[:id])
  end

  def params_group_post
    params.required(:group_post).permit(:content, :image)
  end
end
