class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to chatroom_url
    else
      render 'static/register'
    end
  end

  private

    def user_params
      params.require(:user).permit(*User.create_keys)
    end
end
