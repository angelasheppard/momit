class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def hello
      render html: "default momit home page"
  end
end
