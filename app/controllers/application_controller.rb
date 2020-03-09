class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :nickname, :email, :avatar, :password, :password_confirmation, :profile, :remember_me])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :username, :email, :password, :remember_me])
        devise_parameter_sanitizer.permit(:account_update, keys: [:username, :nickname, :email, :avatar, :password, :password_confirmation, :profile, :current_password])
    end
end