# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  default from: 'Discursus <sales@discursus.com.ua>', reply_to: 'discursus.sales@gmail.com'
  layout 'mailer'
end
