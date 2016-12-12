module OrdersFunctionality
  module StateMachine
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm do
        state :pending, initial: true
        state :submitted
        state :paid_for
        state :completed
        state :failed
        state :canceled

        event :submit, after: :notify_user_no_payment do
          transitions from: [:pending, :submitted], to: :submitted, guard: -> { line_items.present? }
        end

        event :pay, after: :notify_user_payment do
          transitions from: :submitted, to: :paid_for
        end

        # order can be transitioned to completed only by administrator - either from paid_for (when appropriate
        # payment method was selected) or from :submitted (when user pays after receiving books)
        event :success, before: -> { self.completed_at = DateTime.current } do
          transitions from: [:submitted, :paid_for], to: :completed
        end

        event :fail do
          transitions to: :failed
        end

        event :cancel do
          transitions to: :canceled
        end
      end
    end

    private

    # Notify user with email immediately after order submission if they chose to pay after receiving books
    def notify_user_no_payment
    end

    # Notify user with email after payment is successful if they chose to pay immediately
    def notify_user_payment
    end
  end
end
