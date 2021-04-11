class SessionsController < ApplicationController
  def new
  end

  def create
    target = User.where(username: params[:username]).first
    if target.present?
      redirect_to chatroom_url
    else
      render :new
    end
  end
end
