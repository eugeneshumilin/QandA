class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show]
  before_action :load_current_user_question, only: [:destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answers = Answer.with_attached_files.all
    @answer = Answer.new
  end

  def update
    @question.update(question_params)
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, alert: 'Question was successfully deleted'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def load_current_user_question
    @question = current_user.questions.find(params[:id])
  end
end
