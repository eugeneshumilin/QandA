module Liked
  extend ActiveSupport::Concern

  included do
    before_action :set_likable, only: %i[vote_up vote_down]
  end

  def vote_up
    @likable.vote_up(current_user)
    render_json
  end

  def vote_down
    @likable.vote_down(current_user)
    render_json
  end

  private

  def render_json
    render json: { rating: @likable.likes.pluck(:rating).sum, klass: @likable.class.to_s, id: @likable.id }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_likable
    @likable = model_klass.find(params[:id])
  end
end