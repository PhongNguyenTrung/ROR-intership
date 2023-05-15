# This class is responsible for general service
class ApplicationService
  def self.call(*args)
    new(*args).call
  end
end
