class StaticPagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:home]

    def home
    end

    def code_of_conduct
    end

    def guild_policies
    end
end
