require 'rails_helper'

describe 'suggestion', js: true do
  include_context 'setup_OmniAuth_config', :google_oauth2
  before do
    visit user_omniauth_authorize_path(provider: :google_oauth2)
  end

  describe 'send suggestion', js: true do
    let(:suggestion_comment) { 'test_suggestion_comment' }

    context 'visiting event index page, clicking suggest button' do
      before do
        visit events_path
        click_link I18n.t('layouts.suggestion_modal')
      end

      describe 'show suggest modal' do
        it 'contet should has layouts.suggestion_modal_title' do
          expect(page).to have_content I18n.t('layouts.suggestion_modal_title')
        end
        it 'contet should has button(layouts.suggestion_send)' do
          expect(page).to have_selector(:link_or_button, I18n.t('layouts.suggestion_send'))
        end
      end

      before do
        fill_in 'suggestion[comment]', with: suggestion_comment
      end

      context 'clicking send button' do
        it 'suggestion table record is increased by 1' do
          expect { click_button I18n.t('layouts.suggestion_send') }.to change(Suggestion, :count).by(1)
        end
      end

      context 'success send suggestion, and visiting suggestion list page' do
        before do
          click_button I18n.t('layouts.suggestion_send')
          visit suggestions_path
        end

        it 'content should have sent suggestion' do
          expect(page).to have_content suggestion_comment
        end
      end
    end
  end
end
