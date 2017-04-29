module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      user = User.from_omniauth(request.env['omniauth.auth'])

      sign_in(user) if user&.persisted?
      redirect_to root_path
    end

    def google_oauth2
      facebook # The actions are the same as with fb
    end

    def failure
      redirect_to root_path
    end
  end
end
