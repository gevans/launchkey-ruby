class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def launchkey_session
    return @launchkey_session if defined? @launchkey_session

    @launchkey_session = begin
      LaunchKeySession.find(session[:launchkey_session_id])
    rescue
      session[:launchkey_user]       = nil
      session[:launchkey_session_id] = nil
    end
  end

  helper_method :launchkey_session
end
