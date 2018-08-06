class ApplicationPolicy
    attr_reader :current_user, :record

    def initialize(current_user, record)
        @current_user = current_user
        @record = record
    end

    class Scope
        attr_reader :current_user, :scope

        def initialize(current_user, scope)
            @current_user = current_user
            @scope = scope
        end

        def resolve
            scope.all
        end
    end
end
