require 'rails_helper'

# cf http://easyramble.com/request-spec-for-devise-omniatuh.html
describe "Googleのアカウントを使いOmniauthでログインする" do

  context "ログインページに遷移する場合" do

    service  = :google_oauth2
    include_context "setup_OmniAuth_config", service

    before do
      visit "/users/auth/google_oauth2"
    end

    it 'infoページに遷移している' do
      expect( page.current_path ).to eq info_users_path
    end

    it 'ユーザー名が表示されている' do
      expect( page ).to have_content oauth_user.info.name
    end

  end

end
