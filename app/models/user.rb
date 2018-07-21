class User < ApplicationRecord
    enum role: [:guest, :member, :officer, :admin]
    after_initialize :set_default_role, if: :new_record?

    validates :username, uniqueness: { case_sensitive: false }, length: { in: 3..30 }, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true

    def set_default_role
        self.role ||= :guest
    end

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
end
