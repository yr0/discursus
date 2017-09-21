module OrdersFunctionality
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :city, :street, length: { maximum: 250 }
      validates :comment, length: { maximum: 10_000 }
      validates :full_name, :email, length: { maximum: 250 }
      validates :phone, length: { maximum: 50 }
      validates :password, confirmation: true, allow_blank: true, allow_nil: true, length: { minimum: 6, maximum: 250 }
      validate :must_have_email_or_phone, if: -> { submitted? || form_submission_started? }
      validate :email_must_be_unique, if: -> { password.present? && email_changed? }

      # with_options(if: -> { pending? && raw_promo_code&.strip.present? }) do
      #   validate(unless: :promo_code_id) { errors.add(:base, I18n.t('errors.messages.promo_code.blank')) }
      #   validate(if: -> { promo_code_id && promo_code.used_by?(email) }) do
      #     errors.add(:base, I18n.t('errors.messages.promo_code.already_used'))
      #   end
      #   with_options(if: :promo_code_id) do
      #     validate { errors.add(:base, I18n.t('errors.messages.promo_code.expired')) if promo_code.expired? }
      #     validate { errors.add(:base, I18n.t('errors.messages.promo_code.exhausted')) if promo_code.exhausted? }
      #   end
      # end
    end

    def user_errors?
      errors.details.to_json[/(full_name)|(password)|(email)|(phone)/].present?
    end

    private

    # Add validation error if order has digital items and no email to send them to or has password without provided
    # email or either email or phone are blank
    def must_have_email_or_phone
      if needs_email? && email.blank?
        errors.add(:base, :"email_presence_on_#{digital? ? 'digital' : 'account'}")
      elsif email.blank? && phone.blank?
        errors.add(:base, :must_have_email_or_phone)
      end
    end

    def needs_email?
      digital? || password.present?
    end

    # Only called when user chooses to create account with the order - adds error if user with this email already exists
    def email_must_be_unique
      errors.add(:email, :exists) if User.where(email: email).any?
    end
  end
end
