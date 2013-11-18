class LaunchKeySession < ActiveRecord::Base

  before_destroy :deauthorize

  def self.authorize(username)
    create(auth_request: LaunchKey.authorize(username))
  end

  def self.deauthorize(user_hash)
    where(user_hash: user_hash).destroy_all
  end

  def self.authorized?(auth_request)
    find_by(auth_request: auth_request).authorized?
  end

  def authorized?
    auth? && user_hash?
  end

  def deauthorize
    LaunchKey.deauthorize(auth_request)
  end
end
