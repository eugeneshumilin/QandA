class User < ApplicationRecord
  TEMPORARY_EMAIL = 'temporary@email.address'.freeze

  has_many :questions
  has_many :answers
  has_many :badges
  has_many :likes
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]
  
  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def get_reward!(badge)
    badge.update!(user: self)
  end

  def already_liked?(item)
    likes.exists?(likable: item)
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_temporary?
    email =~ /#{TEMPORARY_EMAIL}/
  end
end
