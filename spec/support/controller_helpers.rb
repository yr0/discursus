# frozen_string_literal: true

module ControllerHelpers
  def last_status
    response.status
  end

  def last_headers
    response.headers
  end
end
