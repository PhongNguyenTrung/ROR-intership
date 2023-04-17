class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users.as_json(only: %i[name address phong])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.create!(user_params)
  end

  def update
    @user = User.find(params[:id])
    return unless @user.update(user_params)

    render json: @user
  end

  def destroy
    @user = User.find(params[:id]).destroy
  end

  private

  def user_params
    params.permit(:name, :phong, :address)
  end

  def error_response
    render json: { message: 'Something went wrong!' }
  end
end
