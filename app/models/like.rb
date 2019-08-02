class Like < ApplicationRecord
  belongs_to :likable, polymorphic: true
  belongs_to :user

  validates :rating, presence: true
  validates_numericality_of :rating, only_integer: true
  validates_inclusion_of :rating, in: -1..1
end
