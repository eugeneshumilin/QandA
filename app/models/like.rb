class Like < ApplicationRecord
  belongs_to :likable, polymorphic: true
  belongs_to :user

  validates :rating, presence: true, inclusion: [1, -1]
  validates_numericality_of :rating, only_integer: true
end
