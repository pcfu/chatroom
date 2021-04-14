class SessionsController < ApplicationController
  def new
  end

  def create
    params = create_params
    response = authenticate_user(params[:username], params[:password])
    render response
  end

  private

    def create_params
      params.require(:session).permit(:username, :password)
    end

    def authenticate_user(username, password)
      user = User.where(username: username).first

      if user.present?
        if user.authenticate(password)
          Hash[:json => nil, :status => :ok]
        else
          Hash[:json => { field: :password, msg: 'incorrect password' }, :status => :unauthorized]
        end
      else
        Hash[:json => { field: :username, msg: 'not recognized' }, :status => :unauthorized]
      end
    end
end
