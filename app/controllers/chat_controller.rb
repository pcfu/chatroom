class ChatController < ApplicationController

  def index
    return redirect_to login_url if !logged_in?
  end

  def post_message
    if params['message'].present?
      ActionCable.server.broadcast(
        'chat_main_room', { user: params['user'], message: params['message'] }
      )
    end
  end

end
