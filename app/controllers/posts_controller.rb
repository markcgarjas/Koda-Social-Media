class PostsController < ApplicationController
  Pundit::Authorization
  after_action :verify_authorized, except: [:index, :create, :show]
  before_action :set_post, only: [:edit, :show, :update, :destroy]
  before_action :authenticate_user!, except: :index

  def index
    @posts = current_user.posts.or(Post.public_post).or(Post.where(user: current_user.friends).friends_only) if current_user
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

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def show
    authorize @post, :show?, policy_class: PostPolicy
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
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
    authorize @post, :destroy?, policy_class: PostPolicy
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
