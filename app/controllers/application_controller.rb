class ApplicationController < ActionController::Base
  before_action :check_email_for_update

  def check_email_for_update
    if current_user&.email_temporary?
      return if ['confirmations', 'sessions'].include?(controller_name)
      redirect_to set_email_user_path(current_user)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { head :forbidden }
      format.js { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
