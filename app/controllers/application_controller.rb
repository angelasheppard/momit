class ApplicationController < ActionController::Base
    include Pundit
    protect_from_forgery with: :exception

    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :prepare_exception_notifier

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    #appends extra info to production log
    def append_info_to_payload(payload)
        super
        payload[:http_host] = request.host
        payload[:port] = request.port
        payload[:remote_ip] = request.remote_ip
        payload[:user_agent] = request.user_agent
        payload[:auth_user] = current_user ? current_user.id : nil
        payload[:referer] = request.env["HTTP_REFERER"] || '-'
    end

    private

    def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore

        Log.warn(current_user, "Unauthorized access attempted: #{policy_name}.#{exception_query}")
        flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        redirect_to(request.referrer || root_path)
    end

    def prepare_exception_notifier
        request.env["exception_notifier.exception_data"] = {
            current_user: current_user&.username
        }
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    end

    def after_sign_in_path_for(resource)
        Log.info(current_user, "Logged in")
        root_path
    end
end
