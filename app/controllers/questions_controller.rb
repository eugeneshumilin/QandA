class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: [:show]
  before_action :load_current_user_question, only: %i[destroy update]
  before_action :current_user_to_gon, only: %i[index show]
  after_action :publish_question, only: :create
  before_action :init_comment, only: %i[index show update]

  authorize_resource


  def index
    @questions = Question.all
  end

  def show
    @answers = Answer.with_attached_files.all
    @answer = Answer.new
    @answer.links.build
  end

  def update
    @question.update(question_params)
  end

  def new
    @question = current_user.questions.build
    @question.links.build
    @question.badge ||= Badge.new
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
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: %i[name url],
                                     badge_attributes: %i[title image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      @question.to_json(include: :user)
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def load_current_user_question
    @question = current_user.questions.find(params[:id])
  end

  def current_user_to_gon
    gon.current_user = current_user
  end

  def init_comment
    @comment = Comment.new
  end
end
