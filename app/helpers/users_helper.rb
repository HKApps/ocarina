module UsersHelper
  def defer_dropbox_connect?
    !current_user.dropbox_authenticated? && !!cookies[:defer_dropbox_connect]
  end
end
