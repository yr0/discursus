module Personal
  class PersonalController < ApplicationController
    layout 'personal'
    before_action :authorize_for_personal

    private

    def authorize_for_personal
      authorize! :modify, current_user
    end
  end
end
