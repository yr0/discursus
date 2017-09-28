class ApplicationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  default from: 'discursus-sales@gmail.com'
  layout 'mailer'
end
