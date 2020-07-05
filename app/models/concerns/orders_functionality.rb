# frozen_string_literal: true

# Module for concerns related to order
module OrdersFunctionality
  extend ActiveSupport::Concern
  AUTOCOMPLETE_FIELDS = %w(email phone full_name payment_method shipping_method shipping_service
                           shipping_service_details city street).freeze

  included do
    include StateMachine
    include Validations

    before_create :autocomplete_user_information
  end

  def autocomplete_user_information
    if last_customer_order
      assign_attributes(last_customer_order.as_json.slice(*AUTOCOMPLETE_FIELDS))
    elsif customer.is_a? User
      assign_present_personal_info
    end
  end

  private

  def last_customer_order
    @last_customer_order ||= customer.orders.order(created_at: :desc).first
  end

  def assign_present_personal_info
    user_attributes = { email: customer.email, phone: customer.phone, full_name: customer.name }
    user_attributes.reject! { |k| self[k].present? }
    assign_attributes user_attributes
  end
end
