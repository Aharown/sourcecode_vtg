class ApplicationController < ActionController::Base
  # app/controllers/application_controller.rb
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_categories
  before_action :set_devise_variables
  helper_method :current_cart
  helper_method :cart_count



  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def current_cart
    session[:cart] ||= {}
  end

  def cart_count
    return 0 unless session[:cart].present?
    session[:cart].values.map(&:to_i).sum
  end

  private

  def admin?
    current_user&.admin?
  end

  def require_admin
    unless admin?
      redirect_to garments_path
    end
  end

  def set_categories
    @categories = Category.all
  end

  def rails_admin_path?
    request.fullpath.start_with?('/admin')
  end

  def set_devise_variables
    @resource = User.new
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]
  end
end
