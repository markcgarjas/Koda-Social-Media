class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if Rails.env.development?
      @post.location = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.location = request.remote_ip
    end
    if @post.save
      flash[:notice] = "Post created successfully"
      redirect_to posts_path
    else
      flash[:alert] = @post.errors.full_messages.join(", ")
      redirect_to posts_path
    end
  end

  def edit; end

  def update
    @post.update(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "Post update successfully"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Post delete successfully"
      redirect_to posts_path
    else
      flash[:alert] = @post.errors.full_messages.join(", ")
      redirect_to posts_path
    end
  end

  private

  def post_params
    params.required(:post).permit(:text, :image, :location, :audience)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
