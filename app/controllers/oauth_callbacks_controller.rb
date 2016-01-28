class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    handle_callback
  end

  private

  def handle_callback
    callback_data = extract_callback_data request.env['omniauth.auth']
    access_data = callback_data[:access_data]
    user_data = callback_data[:user_data]

    if user = User.find_by_oauth(access_data[:provider], access_data[:uid])
      # TODO refresh info
    else
      if (not (email = user_data[:email]).nil?) and (not (user = User.find_by_email(email)).nil? )
        # already has user with same email
        if user_signed_in?
          user.oauth_accesses.create access_data
          # update user email unless already got one
          # cause some provider(like github) allow user with blank email
          if user.email.blank? and (not user_data[:email].blank?)
            user.update email: user_data[:email]
          end
        else
          user_previous_provider = user.oauth_accesses.first.provider
          # TODO i18n
          # redirect_to new_user_session_path, notice: "您选择了使用 #{provider_display_name access_data[:provider]} 账户登录，但我们发现已经存在一个使用同样 email 地址的 #{provider_display_name user_previous_provider} 账户。为防止您的账户被人冒领，请先使用 #{provider_display_name user_previous_provider} 账户登录，然后在设置界面中绑定您的 #{provider_display_name access_data[:provider]} 账户。此后您即可以使用任意账户登录。"
          redirect_to new_user_session_path, notice: "You are trying to sign in using your #{provider_display_name access_data[:provider]} account, but we found another user with the same email in our system. For security reasons, your have to sign in with your #{provider_display_name user_previous_provider} account, then you may bind your #{provider_display_name access_data[:provider]} account and then sign in with any of them."
          return
        end
      else
        user = User.new user_data
        user.password = SecureRandom.base64.first(16)
        user.save!
        user.oauth_accesses.create! access_data
      end
    end

    # TODO flash
    if user_signed_in?
      # from dashbaord
      redirect_to dashboard_path(anchor: 'user-info')
    else
      sign_in_and_redirect user, event: :authentication
    end
  end

  def extract_callback_data data
    case data['provider']
    when 'github'
      access_data = {
        provider: data['provider'],
        uid: data['uid'],
        access_token: data['credentials']['token'],
        profile_url: data['info']['urls']['GitHub'],
        profile_name: data['info']['name'],
        avatar_url: data['extra']['raw_info']['avatar_url']
      }
      user_data = {
        email: data['info']['email']
      }
    end

    {
      access_data: access_data,
      user_data: user_data
    }
  end

  def provider_display_name provider
    case provider
    when 'github'
      'Github'
    end
  end
end
