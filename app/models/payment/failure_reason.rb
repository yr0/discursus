# frozen_string_literal: true

class Payment
  class FailureReason < ApplicationRecord
    belongs_to :payment
    validates :reason, presence: true
  end
end
