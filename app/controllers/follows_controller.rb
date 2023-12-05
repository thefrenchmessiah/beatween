class FollowsController < ApplicationController

  def index
    @user = User.find(params[:user_id]) # pag que se visita
    @follows = Follow.all
  end

  def create
    @follow = Follow.new
    @follow.follower = current_user
    @follow.followed = User.find(params[:user_id]) # pagina del usuario que se quiere seguir
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
