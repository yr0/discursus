class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def has_recaptcha_error?
    errors.details.to_json[/reCAPTCHA/].present?
  end
end
