class NotificationMailer < ActionMailer::Base
    default from: "noreply@momitguild.org"
    default to: NOTIFICATION_EMAIL_TO
    if Rails.env == 'production'
        @@app_name = "MOMiT"
    else
        @@app_name = "#{Rails.env} MOMiT"
    end

    def error_email(user, message, diffs, recipient=nil)
        subject = "Error on #{@@app_name}"
        @user = user
        @message = message.html_safe
        @diffs = diffs
        if recipient
            mail(:subject => subject, :to => recipient)
        else
            mail(:subject => subject)
        end
    end

    def alert_email(user, message, diffs, recipient=nil)
        subject = "Alert for #{@@app_name}"
        @user = user
        @message = message.html_safe
        @diffs = diffs
        if recipient
            mail(:subject => subject, :to => recipient)
        else
            mail(:subject => subject)
        end
    end

    def unhandled_error_email(exception, params, request, session, cookies)
        @exception = exception
        @params = params
        @request = request
        @session = session
        @cookies = cookies
        subject = "500 Error on #{@@app_name}"
        mail(:subject => subject)
    end
end
