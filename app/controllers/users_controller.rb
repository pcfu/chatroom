class UsersController < ApplicationController
  def register
    @user = User.new
  end

  def create
    render 'register'
  end
end
