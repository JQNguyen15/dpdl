class User < ActiveRecord::Base
	class << self
		def from_omniauth(auth)
			info = auth['info']
			#convert from 64 bit to 32 bit
			user = find_or_initialize_by(uid: (auth['uid'].to_i - 76561197960265728).to_s)
			user.nickname = info['nickname']
			user.avatar_url = info['image']
			user.profile_url = info['urls']['Profile']
			user.save!
			user
		end
	end
end
