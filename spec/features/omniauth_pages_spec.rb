require 'rails_helper'

# cf http://easyramble.com/request-spec-for-devise-omniatuh.html
describe "Googleのアカウントを使いOmniauthでログインする" do
  service = :google_oauth2
  include_context 'setup_OmniAuth_config', service

  subject { page }

  context "ログインページに遷移する場合" do
    before do
      visit user_omniauth_authorize_path(service)
    end

    it 'infoページに遷移している' do
      expect( page.current_path ).to eq info_users_path
    end

    it 'ユーザー名が表示されている' do
      expect( page ).to have_content oauth_user.info.name
    end
  end

  context '不特定のページに遷移してログインページに遷移する場合' do
    let(:before_logged_in_path) { root_path }
    before do
      visit before_logged_in_path
      page.all("a[href='#{user_omniauth_authorize_path(service)}']").first.click
    end

    it 'ログイン前のページに遷移していること' do
      expect(page.current_path).to eq before_logged_in_path
    end
  end
end
