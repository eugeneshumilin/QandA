class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[set_email confirm_email]
  before_action :check_email, only: %i[set_email confirm_email]
  skip_before_action :check_email_for_update, only: %i[set_email confirm_email]

  def set_email;end

  def confirm_email
    if current_user.update(email: params[:user][:email])
      redirect_to set_email_user_path(current_user)
      flash[:notice] = 'Please check your email'
    else
      render :set_email
    end
  end

  private

  def check_email
    redirect_to root_path unless current_user.email_temporary?
  end
end
