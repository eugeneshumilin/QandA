class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource
  after_action :publish_comment

  authorize_resource

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def find_resource
    @klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    @resource = @klass.find(params["#{@klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @klass == Question ? @resource.id : @resource.question.id

    ActionCable.server.broadcast(
      "question_#{question_id}_comments", {
        comment: @comment,
        user_email: @comment.user.email,
        id: @resource.id
      }.to_json
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end