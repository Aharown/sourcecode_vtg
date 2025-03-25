class ApplicationController < ActionController::Base
  # app/controllers/application_controller.rb
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_categories
  before_action :set_devise_variables
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def set_categories
    @categories = Category.all
  end

  def authenticate_admin!
    authenticate_user!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def set_devise_variables
    @resource = User.new
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end
end
