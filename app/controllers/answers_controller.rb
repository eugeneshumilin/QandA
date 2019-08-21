class AnswersController < ApplicationController
  include Liked

  before_action :authenticate_user!, only: %i[create destroy update set_best]
  before_action :load_question, only: [:create]
  before_action :load_current_user_answer, only: %i[destroy update set_best]
  after_action :publish_answer, only: :create
  before_action :init_comment, only: %i[create update set_best]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def set_best
    @answer.set_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_current_user_answer
    @answer = current_user.answers.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map { |f| { id: f.id, name: f.filename.to_s, url: url_for(f) }}

    ActionCable.server.broadcast(
      "question_#{@answer.question_id}_answers", {
        answer: @answer,
        user: current_user,
        files: files,
        links: @answer.links,
        rating: @answer.stats
      }.to_json
    )
  end

  def init_comment
    @comment = Comment.new
  end
end
