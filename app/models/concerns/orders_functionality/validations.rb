module OrdersFunctionality
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :city, :street, length: { maximum: 250 }
      validates :comment, length: { maximum: 10_000 }
      validates :full_name, length: { maximum: 250 }
      validates :full_name, :email, length: { maximum: 250 }
      validates :phone, length: { maximum: 50 }
      validates :password, allow_nil: true, length: { minimum: 6, maximum: 250 }
      validates :password, confirmation: true, allow_blank: true
      validate :must_have_email_or_phone
      validate :email_must_be_unique, if: -> { password.present? }
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
