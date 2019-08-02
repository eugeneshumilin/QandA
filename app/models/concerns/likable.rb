module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likable
  end

  def vote_up(user)
    likes.create!(user: user, rating: 1)
  end

  def vote_down(user)
    likes.create!(user: user, rating: -1)
  end

  def stats
    likes.sum(:rating)
  end

  def already_liked?(user)
    likes.exists?(user: user)
  end
end