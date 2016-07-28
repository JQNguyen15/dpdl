class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # this method updates the users last active moment
  before_action :record_user_activity
  # general purpose stuff
  private
  	def current_user
  		return nil unless session[:user_id]
  		@current_user ||= User.find_by(id: session[:user_id])
  	end

  	helper_method :current_user

  	def record_user_activity
  		if current_user
  			current_user.touch :last_active_at
  		end
  	end

    def logged_in
      @user = current_user
      if @user
        return true
      else
        flash[:danger] = "Please log in"
        redirect_to root_url
      end
    end

end
