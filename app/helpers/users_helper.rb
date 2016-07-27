module UsersHelper
  #finds a user based on user_id
  def find_user(user_id)
    User.find_by(id: user_id)
  end
end
