class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
         
    validates :username, uniqueness: { case_sensitive: false }, length: { in: 3..30 }
    validates :email, uniqueness: { case_sensitive: false }
end