module AnswersHelper
  def add_class_to_best_answer(answer)
    if answer.is_best?
      'best-answer'
    else
      ''
    end
  end
end
