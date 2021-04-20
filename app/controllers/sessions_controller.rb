class SessionsController < ApplicationController
  include SessionsHelper

  def new
    redirect_to chatroom_url if current_user.present?
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
      user = User.find_by(username: username)
      return unauthorized(:username, 'not recognized') if user.nil?
      return unauthorized(:password, 'incorrect password') if !user.authenticate(password)

      log_in user
      { json: nil, status: :ok }
    end

    def unauthorized(err_field, err_msg)
      { json: { field: err_field, msg: err_msg }, status: :unauthorized }
    end
end
