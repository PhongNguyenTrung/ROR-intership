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
end
