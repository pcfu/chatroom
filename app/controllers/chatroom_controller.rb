class ChatroomController < ApplicationController

  def index
    @user = rand(1..1000).to_s.rjust(4, '0')
  end

  def post_message
    if params['message'].present?
      ActionCable.server.broadcast(
        'chat_main_room', { user: params['user'], message: params['message'] }
      )
    end
  end

end
