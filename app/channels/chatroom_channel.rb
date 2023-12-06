class ChatroomChannel < ApplicationCable::Channel
  # def subscribed
  #   chatroom = Chatroom.find(params[:chatroom_id])
  #   stream_for chatroom
  # end

  def subscribed
    chatroom = Chatroom.find(params[:chatroom_id])
    stream_from "chatroom_#{params[:id]}"
  end

  def receive(data)
    chatroom = Chatroom.find(params[:chatroom_id])
    ActionCable.server.broadcast(chatroom, data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
