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
  end

  def user_abilities
  end
end
