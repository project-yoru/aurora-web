module UsersHelper
  def user_display_name user
    # TODO handle multiple accesses after we allow multiple providers

    access = user.oauth_accesses.first

    unless ( profile_name = access.profile_name ).blank?
      profile_name
    else
      unless ( user_name = access.username ).blank?
        user_name
      else
        user.email
      end
    end
  end
end
