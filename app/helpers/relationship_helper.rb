module RelationshipHelper
	def invite_date(trip)
		invite = current_user.invites.find_by(trip_id: trip.id)
		format_date(invite.created_at)
	end

	def getSender(invite)
		User.find(invite.sender)
	end

  def pending_invites(trip)
    trip.invites.where(rsvped?: nil)
  end

  def leave(trip)
    link_to 'leave trip', leave_trip_path(trip.url), method: :delete, data: {confirm: 'You sure?'}
  end

  def uninvite(trip, invite)
    link_to 'uninvite', uninvite_path(trip.url, getUser(invite).tag), method: :delete, data: {confirm: 'You sure?'}
  end
end
