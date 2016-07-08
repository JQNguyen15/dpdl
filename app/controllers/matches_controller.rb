class MatchesController < ApplicationController

	def index
		@users = User.where(["last_active_at > ?", 1.seconds.ago])

		@allusers = User.all
	end

end
