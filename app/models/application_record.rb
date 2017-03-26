class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def recaptcha_error?
    errors.details.to_json[/reCAPTCHA/].present?
  end
end
