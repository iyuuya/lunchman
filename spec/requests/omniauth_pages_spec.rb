require 'rails_helper'

# cf http://easyramble.com/request-spec-for-devise-omniatuh.html
describe "Googleのアカウントを使いOmniauthでログインする" do

  context "ログインページに遷移する場合" do

    service  = :google_oauth2
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
      provider: service.to_s,
      uid:      '111853197015656344117'#rtomita@aiming-inc.com
    })
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

    let(:oauth_user) { OmniAuth.config.mock_auth[service] }

    before do
      visit "/users/auth/google_oauth2"
    end

    it 'infoページに遷移している' do
      expect( page.current_path ).to eq info_users_path
    end

    it 'ユーザー名が表示されている' do
      expect(page).to have_content oauth_user.info.name
    end

  end

end
