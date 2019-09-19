class Api::V1::AnswersController < Api::V1::BaseController
  before_action :current_resource_owner, only: :create
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show update destroy]

  authorize_resource Answer

  def index
    render json: @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer, serializer: AnswerShowSerializer
  end

  def update
    if @answer.update(answer_params)
      render json: 'your answer successfully updated'
    else
      payload = {
          error: 'invalid params',
          status: 400
      }

      render json: payload, status: :bad_request
    end
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = @current_resource_owner

    if @answer.save
      render json: 'your answer successfully created'
    else
      payload = {
          error: 'invalid params',
          status: 400
      }

      render json: payload, status: :bad_request
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end