# This module is responsible for defining the helper methods belonging to User
module UserHelper
  include JwtToken
  def authenticate_user!
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      error!('401 Unauthorized', 401)
    end
  end

  # def find_by_activation_digest!
  #   activation_digest = params[:activation_digest]
  #   begin
  #     decoded = jwt_decode(activation_digest)
  #     @current_user = User.find(decoded[:user_id])
  #   rescue ActiveRecord::RecordNotFound, JWT::DecodeError
  #     error!('404 Not found', 404)
  #   end
  # end
end
