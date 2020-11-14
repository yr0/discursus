# frozen_string_literal: true

class SeriesController < ApplicationController
  load_resource find_by: :slug, only: :show
end
