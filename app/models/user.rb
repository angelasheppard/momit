class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

    enum role: { guest: 0, initiate: 1, member: 2, officer: 3, admin: 4 }
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

    def thredded_can_read_messageboards
        return get_permitted_messageboards
    end

    def thredded_can_write_messageboards
        writable_boards = get_permitted_messageboards
        if self.guest?
            return writable_boards.where("thredded_messageboards.name = ?", 'Recruitment')
        else
            return writable_boards
        end
    end

    def thredded_can_moderate_messageboards
        return self.admin? ? Thredded::Messageboard.all : []
    end

    private

        def get_permitted_messageboards
            if self.officer?
                return Thredded::Messageboard.all
            else
                member_restricted_boards = ['Officers']
                initiate_restricted_boards = member_restricted_boards.dup.push('Recruit Voting')

                public_group = Thredded::MessageboardGroup.find_by(name: 'Public')
                public_boards = Thredded::Messageboard.by_messageboard_group(public_group)
                momit_group = Thredded::MessageboardGroup.find_by(name: 'MOMiT')
                momit_boards = Thredded::Messageboard.by_messageboard_group(momit_group)
                all_boards = momit_boards.or(public_boards)

                return all_boards.where("thredded_messageboards.name not in (?)", member_restricted_boards) if self.member?
                return all_boards.where("thredded_messageboards.name not in (?)", initiate_restricted_boards) if self.initiate?
                return public_boards if self.guest?
            end
        end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  username               :string(30)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role                  (role)
#  index_users_on_username              (username) UNIQUE
#
