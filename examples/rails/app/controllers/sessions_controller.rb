class SessionsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:webhook]

  def index
    unless launchkey_session
      redirect_to new_session_path
    end

    if launchkey_session.authorized?
      redirect_to root_path
    end
  end

  def new
  end

  def create
    @launchkey_session = LaunchKeySession.authorize(params[:username])

    session[:launchkey_username]   = params[:username]
    session[:launchkey_session_id] = @launchkey_session.id

    redirect_to sessions_path
  end

  def destroy
    launchkey_session && launchkey_session.destroy
    redirect_to root_path
  end

  def webhook
    case
    when params[:deorbit]
      deorbit
    when params[:auth]
      authorize
    end

    render nothing: true, status: :no_content
  end

  protected

  def authorize
    session = LaunchKeySession.find_by(auth_request: params[:auth_request])

    if client.authorized?(params[:auth])
      session.update_attributes(
        auth: params[:auth], user_hash: params[:user_hash]
      )
    else
      session.destroy
    end
  end

  def deorbit
    if user_hash = client.deorbit(params)
      LaunchKeySession.deauthorize(user_hash)
    end
  end

  private

  def client
    LaunchKey.client
  end
end
