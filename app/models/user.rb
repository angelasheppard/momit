class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
    validates :username, uniqueness: { case_sensitive: false }, length: { in: 3..30 }
end