class StaticController < ApplicationController
  def homepage
  end

  def login
  end

  def register
    @user = User.new
  end
end
