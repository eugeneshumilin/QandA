class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def find_resource
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    @resource = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end