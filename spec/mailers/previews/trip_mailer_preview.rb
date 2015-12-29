# Preview all emails at http://localhost:3000/rails/mailers/trip_mailer
class TripMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/trip_mailer/trip_invite
  def trip_invite
    user = User.first
    sender = User.find(3)
    TripMailer.trip_invite(sender, user)
  end

end
