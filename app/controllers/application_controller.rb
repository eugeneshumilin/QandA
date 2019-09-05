class ApplicationController < ActionController::Base
  before_action :check_email_for_update

  def check_email_for_update
    if current_user&.email_temporary?
      return if ['confirmations', 'sessions'].include?(controller_name)
      redirect_to set_email_user_path(current_user)
    end
  end
end
