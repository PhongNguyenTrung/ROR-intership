class AuthenticationController < ApplicationController
  # POST /login
  def login
    @user = User.find_by(email: params[:email].downcase)
    if @user&.authenticate(params[:password])
      payload = { user_id: @user.id }
      token = jwt_encode(payload)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
