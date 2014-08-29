require 'rails_helper'

describe 'event_show', type: :feature do
  let(:event) { FactoryGirl.build(:event) }

  include_context 'setup_OmniAuth_config', :google_oauth2
  before do
    visit user_omniauth_authorize_path(provider: :google_oauth2)
  end

  describe 'creating new event', js: true do
    before do
      visit new_event_path
      page.execute_script("$('.bootstraptimepicker_date').removeAttr('readonly')")
      page.execute_script("$('.bootstraptimepicker_time').removeAttr('readonly')")
      fill_in 'event[name]',              with: event.name
      fill_in 'event[comment]',           with: event.comment
      fill_in 'event[event_at_date]',     with: event.event_at.strftime(I18n.t('date.formats.long'))
      fill_in 'event[event_at_time]',     with: event.event_at.strftime(I18n.t('time.formats.short'))
      fill_in 'event[deadline_at_date]',  with: event.deadline_at.strftime(I18n.t('date.formats.long'))
      fill_in 'event[deadline_at_time]',  with: event.deadline_at.strftime(I18n.t('time.formats.short'))
      fill_in 'event[max_participants]',  with: event.max_participants
    end

    describe 'fillin form' do
      it 'click and increse event count' do
        expect { click_button I18n.t('layouts.event_new_label') }.to change(Event, :count).from(0).to(1)
      end
    end

    describe 'fillin form and click' do
      before do
        click_button I18n.t('layouts.event_new_label')
      end

      it 'should redirect to events#index 'do
        expect(page.current_path).to eq events_path
      end
      it 'should have no error classes in css' do
        expect(page).not_to have_css('div.alert-danger')
      end
      it 'should have event name in content' do
        expect(page).to have_content event.name
      end
      it 'should have leader user name in content' do
        expect(page).to have_content event.leader_user.name
      end

      describe 'show event info page' do
        before do
          click_link event.name
        end

        it 'should have layouts.event_show_top in content'do
          expect(page).to have_content I18n.t('layouts.event_show_top')
        end
        it 'should have event name in content' do
          expect(page).to have_content event.name
        end
      end
    end
  end
end
