module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likable
  end

  def vote_up(user)
    likes.create!(user: user, rating: 1) unless user.already_liked?(id)
  end

  def vote_down(user)
    likes.create!(user: user, rating: -1) unless user.already_liked?(id)
  end

  def stats
    likes.sum(:rating)
  end
end