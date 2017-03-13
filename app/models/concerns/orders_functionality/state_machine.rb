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

        event :submit, after: :on_submit_actions do
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

    def on_submit_actions
      swap_customer_with_new_user if customer_type == 'TemporaryUser' && email.present? && password_digest.present?
      notify_on_cash_payment if cash?
    end

    # Notify user with email after payment is successful if they chose to pay immediately
    def notify_user_payment
      OrderMailer.notify_card(self).deliver_later if card?
    end

    # Notify user with email immediately after order submission if they chose to pay after receiving books
    def notify_on_cash_payment
      OrderMailer.notify_cash(self).deliver_later
    end

    def swap_customer_with_new_user
      user = User.create(email: email, encrypted_password: password_digest, name: full_name, phone: phone)
      TemporaryUser.find(customer_id).destroy!
      update!(customer: user)
    end
  end
end
