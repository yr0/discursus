class OrderMailerPreview < ActionMailer::Preview
  def notify_cash
    build_order
    OrderMailer.notify_cash(@order)
  end

  def notify_card
    build_order
    OrderMailer.notify_card(@order)
  end

  private

  def build_order
    user = User.find_or_initialize_by(email: 'foremailpreviews@discursus.com')
    user.assign_attributes(FactoryGirl.attributes_for(:user).except(:email))
    user.save
    @order = user.orders.first || FactoryGirl.create(:order, :with_line_items, customer: user)
  end
end
