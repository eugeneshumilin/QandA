class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :set_best]
  before_action :load_question, only: [:create]
  before_action :load_current_user_answer, only: [:destroy, :update, :set_best]

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
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_current_user_answer
    @answer = current_user.answers.find(params[:id])
  end
end
