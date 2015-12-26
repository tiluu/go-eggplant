class TripMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trip_mailer.trip_invite.subject
  #
  def trip_invite(sender,user)
    @user = user
    @sender = sender.name
    mail to: user.email, subject: "Trip Invite from #{@sender}" 
  end
end
