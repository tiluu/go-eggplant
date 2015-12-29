module RelationshipHelper
	def invite_date(trip)
		invite = current_user.trip_invites.find_by(invited_trip_id: trip.id)
		format_date(invite.created_at)
	end
end
