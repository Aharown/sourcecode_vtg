class ApplicationController < ActionController::Base
  # app/controllers/application_controller.rb
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_categories

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def set_categories
    @categories = Category.all
  end
end
