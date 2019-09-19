class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource User

  def me
    render json: current_resource_owner, serializer: ProfileSerializer
  end

  def index
    render json: users_without_current_user, each_serializer: ProfileSerializer
  end

  private

  def users_without_current_user
    @users ||= User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end