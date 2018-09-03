class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

    enum role: [:guest, :initiate, :member, :officer, :admin]
    after_initialize :set_default_role, if: :new_record?

    validates :username, uniqueness: { case_sensitive: false }, length: { in: 3..30 }, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true
    validates :role, presence: true

    scope :ordered_by_username, -> { order('username ASC') }
    scope :admins, -> { where(role: 'admin') }

    def set_default_role
        self.role ||= :guest
    end

    def initiate?
        return User.roles[self.role] >= User.roles[:initiate]
    end

    def member?
        return User.roles[self.role] >= User.roles[:member]
    end

    def officer?
        return User.roles[self.role] >= User.roles[:officer]
    end

    def thredded_admin?
        return self.role == 'admin'
    end

end
