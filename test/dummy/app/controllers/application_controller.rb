class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper

  def require_admin
    return false
  end

  def authenticate_lite
    return true
  end
end
