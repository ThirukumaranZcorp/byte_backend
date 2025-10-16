class UserMailer < ApplicationMailer

    default from: "noreply@bytesexchange.com"

    def welcome_email(user)
        @user = user
        mail(
        to: @user.email,
        subject: "Welcome to Bytes Exchange — Let’s Get Started!"
        )
    end
end
