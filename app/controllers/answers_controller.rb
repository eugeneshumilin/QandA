class AnswersController < ApplicationController
  def new
    @answer = question.answers.build
  end

  def create
    @answer = question.answers.build(answer_params)

    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end
end
