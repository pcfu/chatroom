class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.save

    redirect_to register_url
  end

  private

    def user_params
      params.require(:user).permit(*User.create_keys)
    end
end
