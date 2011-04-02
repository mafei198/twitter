class PagesController < ApplicationController
  def home
    @title = "home"
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
