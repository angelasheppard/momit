class StaticPagesController < ApplicationController
    skip_before_action :authenticate_user!,
        only: [ :home,
                :code_of_conduct,
                :guild_policies ]

    def home
    end

    def code_of_conduct
        @title = 'Code of Conduct'
    end

    def guild_policies
        @title = 'Guild Policies'
    end
end
