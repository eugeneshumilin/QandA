class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  scope :by_best, -> { order(is_best: :desc, created_at: :desc) }


  def set_best
    old_best = question.answers.find_by(is_best: true)

    transaction do
      old_best.update!(is_best: false) if old_best
      update!(is_best: true)
    end
  end
end
