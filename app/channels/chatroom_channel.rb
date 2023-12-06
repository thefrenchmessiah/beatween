class ChatroomChannel < ApplicationCable::Channel
  # def subscribed
  #   chatroom = Chatroom.find(params[:chatroom_id])
  #   stream_for chatroom
  # end
  def subscribed
    chatroom = Chatroom.find(params[:chatroom_id])
    p "we have id #{chatroom}"
    stream_for chatroom
  end
  
  def receive(data)
    chatroom = Chatroom.find(params[:chatroom_id])
    ActionCable.server.broadcast("chatroom_#{chatroom.id}", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end