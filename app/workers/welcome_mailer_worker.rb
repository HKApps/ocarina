class WelcomeMailerWorker
  include SuckerPunch::Job

  def perform(user_id)
    user = User.fetch(user_id)
    UserMailer.welcome_email(user).deliver
  end
end
