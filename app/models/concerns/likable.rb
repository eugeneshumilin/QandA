module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likable
  end

  def vote_up(user)
    to_vote(user, 1)
  end

  def vote_down(user)
    to_vote(user, -1)
  end

  def stats
    likes.sum(:rating)
  end

  private

  def to_vote(user, rating)
    likes.create!(user: user, rating: rating) unless user.already_liked?(id)
  end
end
