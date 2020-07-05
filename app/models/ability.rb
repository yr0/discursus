class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    can :read, [Book, Article, TeamMember, Bookstore, Author]
    return if user.blank? # user is a guest

    user_abilities
    admin_abilities if user.is_a?(Admin)
  end

  private

  def admin_abilities
    can :index, AdminPanel::DashboardController
    can :manage, [Book, Article, TeamMember, Bookstore, Author, Order, PromoCode, Setting]
  end

  def user_abilities
    can :modify, @user
    can :toggle_favorite, Book
  end
end
