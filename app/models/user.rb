class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

    enum role: [:guest, :initiate, :member, :officer, :admin]
    after_initialize :set_default_role, if: :new_record?

    validates :username, uniqueness: { case_sensitive: false }, length: { in: 3..30 }, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true
    validates :role, presence: true

    scope :ordered_by_username, -> { order('username ASC') }

    def set_default_role
        self.role ||= :guest
    end

end
