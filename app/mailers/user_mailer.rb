class UserMailer < ActionMailer::Base
  default from: "team@playedby.me <team@playedby.me>"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Playedby.me!")
  end
end
