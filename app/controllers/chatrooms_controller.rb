class ChatroomsController < ApplicationController
  before_action :set_users

  def index
    @chatrooms = Chatroom.all(@generator)
  end

  def new
    @chatroom = Chatroom.new
  end

  def create
    @chatroom.generator = @generator
    @chatroom.buddy = @buddy
    @chatroom.name = "with " + @buddy.display_name
  
    if @chatroom.save
      redirect_to user_chatrooms_path
    else
      render 'create', status: :unprocessable_entity
    end
  end


  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  private
  def set_users
    @generator = current_user
    @buddy = User.find(params[:user_id])
  end

end
