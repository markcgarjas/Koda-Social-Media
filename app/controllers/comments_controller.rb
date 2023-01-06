class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @post.comments.build(params_comment)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comment was created successfully."
      redirect_to post_path(@post)
    else
      flash[:alert] = @comment.errors.full_messages.join(", ")
      redirect_to post_path(@post)
    end
  end

  def edit
    authorize @comment, :edit?, policy_class: CommentPolicy
  end

  def update
    authorize @comment, :update?, policy_class: CommentPolicy
    if @comment.update(params_comment)
      flash[:notice] = "Comment was updated successfully."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    authorize @comment, :destroy?, policy_class: CommentPolicy
    @comment.destroy
    flash[:notice] = "Comment was deleted successfully."
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def params_comment
    params.require(:comment).permit(:content)
  end
end
