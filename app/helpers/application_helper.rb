module ApplicationHelper
  # putting in methods that help display the page in here

  def page_header(text)
    content_for(:page_header) { text.to_s.html_safe }
  end

  # gets list of online users
  def online_users
    User.where(["last_active_at > ?", 5.minutes.ago])
  end

  # open games
  def open_games
    Game.where(["started = ? AND finished = ?", false, false])
  end

  # in progress games
  def in_progress_games
    Game.where(["started = ?", true])
  end

  def finished_games
    Game.where(["finished = ?", true])
  end
end
