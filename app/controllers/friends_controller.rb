class FriendsController < ApplicationController
  before_action :set_friend, only: :destroy

  def index
    @friends = current_user.friends
  end

  def destroy
    if current_user.friends.destroy(@friend)
      flash[:notice] = "#{@friend.email} are no longer friends"
      redirect_to friends_path
    else
      flash[:alert] = current_user.errors.full_messages.join(", ")
      redirect_to friends_path
    end
  end

  private

  def set_friend
    @friend = current_user.friends.find(params[:id])
  end
end
