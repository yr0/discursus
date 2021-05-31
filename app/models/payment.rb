# frozen_string_literal: true

class Payment < ApplicationRecord
  PAYMENT_METHODS = %w(card cash).freeze

  belongs_to :order
  has_one :failure_reason, dependent: :destroy

  validates :amount, numericality: { greater_than: 0 }
  validates :payment_method, inclusion: { in: PAYMENT_METHODS }

  include AASM

  aasm(column: :status) do
    state :initiated, initial: true
    state :succeeded
    state :failed

    event :succeed, after: :recalculate_order do
      transitions from: :initiated, to: :succeeded
    end

    event :fail, before: ->(reason) { create_failure_reason(reason: reason) && order.reopen! } do
      transitions from: :initiated, to: :failed
    end
  end

  private

  def recalculate_order
    order.with_lock do
      order.recalculate_balance

      order.pay! if order.reload.balance <= 0
    end
  end
end
