class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :trackable and :omniauthable
  attr_accessor :login
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable, :authentication_keys => [:login]

  validates :username,
  length: { minimum: 4, maximum: 20 },
  format: { with: /\A[a-z0-9]+\z/, message: "ユーザー名は半角英数字です"}
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end
  
end
