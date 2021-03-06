class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    # :registerable,
    # :recoverable, :rememberable,
    :trackable,
    # :validatable
    :omniauthable, :omniauth_providers => [:github]

  has_many :oauth_accesses, dependent: :destroy
  has_many :projects

  def self.find_by_oauth provider, uid
    OauthAccess.find_by(provider: provider, uid: uid).try :user
  end

end
