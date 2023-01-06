class UserPostListsController < ApplicationController
  def index
    @posts = Post.where(user: pundit_user).public_post if params[:post] == 'public'
    @posts = Post.where(user: pundit_user).private_post if params[:post] == 'private'
    @posts = Post.where(user: pundit_user).friends_only if params[:post] == 'friends_only'
  end
end
