class FriendRequestsController < ApplicationController
  before_action :set_friend_request, except: [:index, :create]

  def index
    @friend_request = FriendRequest.where(friend: current_user)
    @sent_request = current_user.friend_requests
    @users = User.where.not(id: [current_user.id] + @sent_request.pluck(:friend_id) + @friend_request.pluck(:user_id))
  end

  def create
    friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.new(friend: friend)
    if @friend_request.save
      flash[:notice] = "Friend request to #{friend.email}"
      redirect_to friend_requests_path
    else
      flash[:alert] = @friend_request.errors.full_messages.join(", ")
      redirect_to friend_requests_path
    end
  end

  def destroy
    if @friend_request.destroy
      flash[:notice] = "Cancel friend request to #{@friend_request.friend.email}"
      redirect_to friend_requests_path
    else
      flash[:alert] = @friend_request.errors.full_messages.join(", ")
      redirect_to friend_requests_path
    end
  end

  def update
    if @friend_request.accept
      flash[:notice] = "You and #{@friend_request.friend.email} are friends now"
      redirect_to friend_requests_path
    else
      flash[:alert] = @friend_request.errors.full_messages.join(", ")
      redirect_to friend_requests_path
    end
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
