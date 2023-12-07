class ChatroomsController < ApplicationController
  before_action :set_users

  def index
    query = params[:search].present? ? params[:search][:query] : ""
      if query.present?
        @chatrooms = Chatroom.where("generator_id = ? AND name ILIKE ?", @generator.id, "%#{query}%")
      else
        @chatrooms = Chatroom.where(generator_id: @generator.id)
      end
  end

  def new
  query = params[:search].present? ? params[:search][:query] : ""
    if query.present?
      @users = @generator.following_users.where('display_name ILIKE ?', "%#{query}%")
    else
      @users = @generator.following_users
    end
  @chatroom = Chatroom.new
end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.generator_id = params[:user_id]
    @chatroom.name = @buddy.display_name

    if @chatroom.save
      redirect_to user_chatroom_path(@generator, @chatroom), notice: 'Chatroom was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def destroy
    @chatroom = Chatroom.find(params[:id])
    @chatroom.destroy
    redirect_to user_chatrooms_path(@generator), notice: 'Chatroom was successfully destroyed.'
  end

  private

  def set_users
    @generator = current_user
    @buddy = User.find(params[:user_id])
  end

  def chatroom_params
    params.require(:chatroom).permit(:buddy_id)
  end

end
