module RelationshipHelper
	def invite_date(trip)
		invite = current_user.invites.find_by(trip_id: trip.id)
		format_date(invite.created_at)
	end

	def getSender(invite)
		User.find(invite.sender)
	end
end
