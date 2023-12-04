class ChatroomsController < ApplicationController
  before_action :set_users

  def index
    @user = current_user
    @chatrooms = Chatroom.all
  end

  def new
    @user = current_user
    @chatroom = Chatroom.new
    @users = User.all
  end

  def create
    @user = current_user
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.generator_id = @user.id
    @chatroom.name = "with " + @buddy.display_name
  
    if @chatroom.save
      redirect_to user_chatroom_path(@user, @chatroom), notice: 'Chatroom was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show
    @user = current_user
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  private
  def set_users
    @generator = current_user
    @buddy = User.find(params[:user_id])
  end

  def chatroom_params
    params.require(:chatroom).permit(:buddy_id)
  end

  # def msg_params
  #   params.require(:message).permit(:content)
  # end

end
