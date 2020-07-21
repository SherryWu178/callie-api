class AuthenticationController < ApplicationController
    skip_before_action :authorize_request
  
    def login
      token = AuthenticateUser
        .new(auth_params[:email], auth_params[:password])
        .token
      render json: { user: user, token: token}
    end
  
    private
    def user
      User
        .find_by(email: auth_params[:email])
        .as_json(except: :password)
    end
    def auth_params
      params.require(:authentication).permit(:email, :password)
    end
  end