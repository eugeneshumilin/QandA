class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource Question

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question, serializer: QuestionShowSerializer
  end
end