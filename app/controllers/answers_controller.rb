class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created.'
    else
      redirect_to question_path(@question), notice: "Body can't be blank"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
