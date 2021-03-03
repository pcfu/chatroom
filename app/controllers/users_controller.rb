class UsersController < ApplicationController
  def register
    @user = User.new
  end
end
