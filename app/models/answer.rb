class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  scope :by_best, -> { order(is_best: :desc, created_at: :desc) }


  def set_best
    old_best = question.answers.find_by(is_best: true)

    transaction do
      old_best&.update!(is_best: false)
      update!(is_best: true)
    end
  end
end
