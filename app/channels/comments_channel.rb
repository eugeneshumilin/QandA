class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params[:question_id]}_comments"
  end
end