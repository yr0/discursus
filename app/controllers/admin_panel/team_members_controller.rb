# frozen_string_literal: true

module AdminPanel
  class TeamMembersController < AdminPanelController
    include RestfulActions

    private

    def record_params
      params.require(:team_member).permit(:name, :role, :motto, :position, :image, :image_cache)
    end
  end
end
