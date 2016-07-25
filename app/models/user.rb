class User < ActiveRecord::Base
	class << self
		def from_omniauth(auth)
			info = auth['info']
			user = find_or_initialize_by(uid: (auth['uid']))
			user.nickname = info['nickname']
			user.avatar_url = info['image']
			user.profile_url = info['urls']['Profile']
			user.save!
			user
		end
	end
end
