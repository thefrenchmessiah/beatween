class FollowsController < ApplicationController

  def index
    @follows = Follow.all
    @user = User.find(params[:user_id])
  end

  def create
    @follow = Follow.new
    @follow.follower = current_user
    @follow.followed = User.find(params[:user_id])
    if @follow.save
      redirect_to user_path(:user_id)
    else
      render 'users/show', status: :unprocessable_entity
    end
  end

  def destroy
    @follow = Follow.find_by(follower: current_user, followed: params[:user_id])
    @follow.destroy
    redirect_to user_path(params[:user_id]), status: :see_other
  end
end
