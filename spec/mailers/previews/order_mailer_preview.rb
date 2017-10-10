class OrderMailerPreview < ActionMailer::Preview
  def notify_cash
    recreate_order
    OrderMailer.notify_cash(@order)
  end

  def notify_card
    recreate_order
    OrderMailer.notify_card(@order)
  end

  private

  def recreate_order
    @order = FactoryGirl.create(:order, customer: user)
    @order.populate(book, :hardcover)
    @order.raw_promo_code = promo.code
    @order.save
  end

  def user
    return @user if @user.present?
    @user = User.find_or_initialize_by(email: 'foremailpreviews@discursus.com')
    @user.assign_attributes(FactoryGirl.attributes_for(:user).except(:email))
    @user.save!
    @user.orders.all.each(&:destroy)
    @user
  end

  def promo
    return @promo if @promo.present?
    @promo = PromoCode.find_or_initialize_by(code: 'TESTING ORDER MAILER')
    @promo.assign_attributes(discount_percent: 50, expires_at: 1.day.since)
    @promo.save
    @promo
  end

  def book
    return @book if @book.present?
    @book = Book.find_by(title: 'TESTING ORDER MAILER')
    @book ||= FactoryGirl.create(:book, :hardcover, title: 'TESTING ORDER MAILER')
  end
end
