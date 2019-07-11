class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_question, only: [:create]
  before_action :load_current_user_answer, only: [:destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    current_question = @answer.question
    @answer.destroy
    redirect_to current_question, alert: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_current_user_answer
    @answer = current_user.answers.find(params[:id])
  end
end
