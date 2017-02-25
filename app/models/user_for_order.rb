class UserForOrder
  include ActiveModel::Model

  attr_accessor *%i(name phone email password password_confirmation)

  validates :name, length: { maximum: 250 }
  validates :name, :email, :password, length: { maximum: 250 }
  validates :phone, length: { maximum: 50 }
  validate :must_have_email_or_phone
  validate :password_and_confirmation_must_match, if: -> { password.present? }

  private

  def must_have_email_or_phone
    errors.add(:base, :must_have_email_or_phone) if email.blank? && phone.blank?
  end

  def password_and_confirmation_must_match
    errors.add(:password_confirmation, :does_not_match_password) unless password == password_confirmation
  end
end
