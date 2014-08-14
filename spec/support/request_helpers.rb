include Warden::Test::Helpers

# cf) http://easyramble.com/request-spec-for-devise-omniatuh.html
# cf) パーフェクトRails p259-260


module RequestHelpers

  def login(user)
    login_as user, scope: :user
  end

  def set_omniauth(service = :google_oauth2 )
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
      provider: service.to_s,
      uid:      '111853197015656344117'#rtomita@aiming-inc.com
    })


    case service
    when :google_oauth2
      OmniAuth.config.add_mock(service, #https://github.com/zquestz/omniauth-google-oauth2#auth-hash
        { info: {
            email: "rtomita@aiming-inc.com",
            name: "富田理央"
            },
          extra: {
            raw_info: {
              name: "富田理央"
            }
          }
        }
      )
    # when :facebook
    #   OmniAuth.config.add_mock(service,
    #     { info: {
    #         email: "#{service.to_s}_oauth_user@example.com"
    #         },
    #       extra: {
    #         raw_info: {
    #           name: "#{service.to_s}_oauth_user"
    #         }
    #       }
    #     }
    #   )
    # when :twitter
    #   OmniAuth.config.add_mock(service,
    #     { info: {
    #         nickname: "#{service.to_s}_oauth_user"
    #       }
    #     }
    #   )
    end

    p OmniAuth.config.mock_auth[service]

    OmniAuth.config.mock_auth[service]
  end

  def login_with_omniauth(service = :google_oauth2 )
    # visit "/users/auth/#{service.to_s}"
    # user_omniauth_authorize_path(:google_oauth2)
    visit "/users/info/"
  end
end
