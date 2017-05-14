class ApplicationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  default from: 'hello@discursus.com'
  layout 'mailer'
end
