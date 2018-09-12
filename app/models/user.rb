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

    def thredded_can_read_messageboards
        return get_permitted_messageboards
    end

    def thredded_can_write_messageboards
        writable_boards = get_permitted_messageboards
        if self.guest?
            return writable_boards.select{|b| b.name == 'Recruitment'}
        else
            return writable_boards
        end
    end

    private

        def get_permitted_messageboards
            if self.officer?
                return Thredded::Messageboard.all
            else
                member_restricted_boards = ['Officers']
                initiate_restricted_boards = member_restricted_boards.push('Recruit Voting')

                public_group = Thredded::MessageboardGroup.find_by(name: 'Public')
                public_boards = Thredded::Messageboard.by_messageboard_group(public_group)
                momit_group = Thredded::MessageboardGroup.find_by(name: 'MOMiT')
                momit_boards = Thredded::Messageboard.by_messageboard_group(momit_group)
                all_boards = public_boards + momit_boards

                return all_boards.reject{ |mb| member_restricted_boards.include?(mb.name) } if self.member?
                return all_boards.reject{ |mb| initiate_restricted_boards.include?(mb.name) } if self.initiate?
                return public_boards if self.guest?
            end
        end
end
