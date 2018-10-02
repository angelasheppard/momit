class StaticPagesController < ApplicationController
    skip_before_action :authenticate_user!,
        only: [ :home,
                :code_of_conduct,
                :guild_policies,
                :loot_philosophy,
                :loot_system ]

    def home
    end

    def code_of_conduct
        @title = 'Code of Conduct'
    end

    def guild_policies
        @title = 'Guild Policies'
    end

    def loot_philosophy
        @title = 'Loot Philosophy'
    end

    def loot_system
        @title = 'Loot System'
    end

end
