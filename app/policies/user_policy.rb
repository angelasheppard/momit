class UserPolicy < ApplicationPolicy
    def index?
        @current_user.officer?
    end

    def show?
        @current_user.member?
    end

    def create?
        true
    end

    def edit?
        @current_user.admin?
    end

    def update?
        @current_user.admin?
    end

    def destroy?
        @current_user.admin?
    end

    class Scope < Scope
        def resolve
            scope.all
        end
    end
end
