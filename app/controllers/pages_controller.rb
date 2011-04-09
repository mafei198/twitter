class PagesController < ApplicationController
  def home
    @title = "home"
    @micropost = Micropost.new if signed_in?
    @feed_items = current_user.feed.paginate(:page => params[:page])
  end

  def contact
    @title = "contact"
  end

  def about
    @title = "title"
  end

  def help
    @title = "help"
  end

  def signup
    @title = "signup"
  end

end
