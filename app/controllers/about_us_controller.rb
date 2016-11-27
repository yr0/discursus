class AboutUsController < ApplicationController
  def index
    @members = TeamMember.all
  end
end
