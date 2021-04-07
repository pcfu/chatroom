class StaticController < ApplicationController
  def homepage
  end

  def register
    @user = User.new
  end
end
