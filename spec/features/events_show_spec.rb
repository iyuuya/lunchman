require 'rails_helper'

describe 'event_show' do
  describe 'GET show' do

    include_context 'setup_OmniAuth_config', :google_oauth2
    before do
      visit user_omniauth_authorize_path(provider: :google_oauth2)
    end

    context 'giving valid data' do
      let(:event) { FactoryGirl.create(:event) }

      before do
        visit event_path(event)
      end

      it 'should have event name in content' do
        expect(page).to have_content event.name
      end
    end

    context 'deadline_at is not set' do
      let(:event_no_deadline_at) { FactoryGirl.create(:event, deadline_at: nil) }

      before do
        visit event_path(event_no_deadline_at)
      end

      it 'should have content layouts.not_setting' do
        expect(page).to have_content I18n.t('layouts.not_setting')
      end
    end

    context 'status is not normal' do
      let(:event_not_status_normal) { FactoryGirl.create(:event, status: Event.statuses[:cancel]) }

      before do
        visit event_path(event_not_status_normal)
      end

      it 'should have content layouts.not_setting' do
        expect(page).to have_content I18n.t('layouts.event_status_not_participable')
      end
    end
  end
end
