require 'rails_helper'

describe 'navigation' do
  let(:navbar) { page.find('#main-navbar') }

  context 'ログインしているとき' do
    include_context 'login_as_user'
    before { visit root_path }
    let(:dropdown)      { navbar.find('.dropdown') }
    let(:dropdown_menu) { navbar.find('.dropdown-menu') }

    it 'ドロップダウンにユーザー名が表示されていること' do
      expect(dropdown).to have_content(login_user.name)
    end

    it 'メニューに「ユーザー登録情報」リンクがあること' do
      expect(dropdown_menu).to have_link I18n.t('layouts.user_info')
    end

    it 'メニューに「ログアウト」リンクがあること' do
      expect(dropdown_menu).to have_link I18n.t('layouts.link_logout')
    end
  end

  context 'ログインしていないとき' do
    before { visit root_path }

    it 'ログインボタンが表示されていること' do
      expect(navbar).to have_link I18n.t('layouts.link_login')
    end
  end
end
