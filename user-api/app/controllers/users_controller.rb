# This controller handles for the user.
class UsersController < ApplicationController
  before_action :find_user, only: %i[show update destroy]
  before_action :authenticate_user, only: %i[current_user update destroy]
  # POST /signup
  def signup
    @user = User.new(user_params)
    return render json: { error: @user.errors.full_messages }, status: :bad_request unless @user.save
  end

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show; end

  # POST /users
  def create
    @user = User.create!(user_params)
  end

  # PUT /users/:id
  def update
    error_message = { error: "You don't have permission to update this user" }
    return render json: error_message, status: :forbidden unless @current_user.id == @user.id
    return render json: { error: @user.errors.full_messages } unless @user.update(update_params)
  end

  # DELETE /users/:id
  def destroy
    error_message = { error: "You don't have permission to destroy this user" }
    return render json: error_message, status: :forbidden unless @current_user.id == @user.id
    return render json: { error: @user.errors.full_messages } unless @user.destroy
  end

  # GET /current_user
  def current_user; end

  private

  def user_params
    params.permit(:name, :phone, :address, :email, :password, :password_confirmation)
  end

  def update_params
    params.permit(:name, :phone, :address, :email)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      @decoded = jwt_decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
