# This class is responsible for defining the Mailer interface
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  layout 'mailer'
end
