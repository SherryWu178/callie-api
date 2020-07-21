class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create, :index]
  def index
      # for testing, PLEASE OMIT in production
      render json: User.all
  end
  
  def create
      begin
          @user = User.create(user_params)
          jwt_token = AuthenticateUser.new(@user.email, @user.password).token
          render json: { user: @user, token: jwt_token }
      rescue ActiveRecord::RecordInvalid => invalid
          render json: { 
              message: "#{Message.account_not_created} #{invalid.record.errors}"
          }, status: :unprocessable_entity
      end
  end

  def show
      render json: @current_user, include: [:events, :activities, :deadlines]
  end

  def update
      begin
          @current_user.update(user_params)
      rescue ActiveRecord::RecordNotSaved => invalid
          render json: {
              message: "#{Message.update_failed} #{invalid.record.errors}"
          }, status: :unprocessable_entity
      end
  end

  def destroy
      begin
          User.destroy(@current_user.id)
          render json: { message:  Message.account_deleted }
      rescue ActiveRecord::RecordNotDestroyed => invalid
          render json: {
              message: "#{Message.account_not_deleted} #{invalid.record.errors}"
          }, status: :unprocessable_entity
      end
  end

  private
  def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end