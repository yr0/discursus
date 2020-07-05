# frozen_string_literal: true

class AboutUsController < ApplicationController
  def index
    @members = TeamMember.all
  end
end
