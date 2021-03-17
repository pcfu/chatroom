class StaticController < ApplicationController
  def register
    @user = User.new
  end
end
