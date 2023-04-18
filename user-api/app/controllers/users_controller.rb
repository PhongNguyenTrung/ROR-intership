class UsersController < ApplicationController
  before_action :find_user, only: %i[show update destroy]
  before_action :authenticate_user, only: %i[get_current_user]

  # POST /signup
  def signup
    @user = User.new(user_params)
    return render json: { error: @user.errors.full_messages }, status: :unauthorized unless @user.save
  end

  # GET /users
  def index
    @users = User.all
    render json: @users.as_json(only: %i[id name email phone address]), status: :ok
  end

  # GET /users/:id
  def show; end

  # POST /users
  def create
    @user = User.create!(user_params)
  end

  # PUT /users/:id
  def update
    return render json: { error: @user.errors.full_messages } unless @user.update(user_params)

    render json: @user, status: :ok
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
  end

  # GET /current_user
  def get_current_user
    render json:  { user: @current_user.as_json( except: :password_digest)}, status: :ok
  end

  private

  def user_params
    params.permit(:name, :phone, :address, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = jwt_decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
