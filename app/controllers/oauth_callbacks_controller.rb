class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_with_oauth

  def github;end

  def vkontakte;end

  private

  def sign_in_with_oauth
    @auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@auth)

    @user&.persisted? ? sign_in_user : redirect_to(root_path, alert: 'Something went wrong')
  end

  def sign_in_user
    if @user.email_temporary?
      sign_in @user
      redirect_to set_email_user_path(current_user)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize) if is_navigational_format?
    end
  end
end