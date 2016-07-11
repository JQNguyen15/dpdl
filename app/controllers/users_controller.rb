class UsersController < ApplicationController
	def _index
		@users = User.where(["last_active_at > ?", 5.seconds.ago])
	end
end
