class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user # user is a guest
    user_abilities
    admin_abilities if user.is_a?(Admin)
  end

  private

  def admin_abilities
    can :index, AdminPanel::DashboardController
    can :manage, [Book, Article, TeamMember]
  end

  def user_abilities
    can :read, [Book, Article, TeamMember]
  end
end
