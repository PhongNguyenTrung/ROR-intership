# This class is responsible for generating error
class ApplicationError < StandardError
  attr_reader :message, :code

  def initialize(message = 'Bad Request', code = 400)
    @message = message
    @code = code
    super(message)
  end
end
