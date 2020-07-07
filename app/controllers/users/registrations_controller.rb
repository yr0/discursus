# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # POST /resource
    def create
      if Rails.configuration.disable_recaptcha || verify_recaptcha
        super
      else
        self.resource = User.new sign_up_params
        resource.validate # Look for any other validation errors besides reCAPTCHA
        set_minimum_password_length

        flash[:alert] = I18n.t('recaptcha_failed')
        respond_with_navigational(resource) { render :new }
      end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i(name email password password_confirmation))
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
